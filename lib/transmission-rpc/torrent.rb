module Transmission
	module RPC
		# A nice wrapper around Transmission's RPC
		class Torrent
			attr_accessor :id, :seeders, :leechers, :name, :download_directory, :eta, :percent_done, :files, :total_size, :date_added, :bytes_left, :comment, :description, :torrent_file, :hash, :status
			include Transmission::RPC
			
			def initialize(options = {})
				self.id 					= options['id']
				self.date_added 	= options['addedDate']
				self.comment 			= options['comment']
				self.eta 					= options['eta']
				self.bytes_left 	= options['leftUntilDone'] 
				self.name         = options['name']
				self.percent_done = options['percentDone']
				self.torrent_file = options['torrentFile']
				self.total_size   = options['totalSize']
				self.hash  				= options['hashString']
				self.status 			= options['status']
			end

			# Starts downloading the current torrent
			def start!
				Client.request("torrent-start", nil, [self.id])
			end

			# Stops downloading the current torrent
			def stop!
				Client.request("torrent-stop", nil, [self.id])
			end

			# Deletes the current torrent, and, optionally, the data for that torrent
			def delete!(delete_data = false)
				Client.request("torrent-remove", { :delete_local_data => delete_data }, [self.id])
			end

			# Checks if torrent is currently downloading
			def downloading?
				self.status == 4
			end

			# Checks if torrent is paused 
			def paused?
				self.status == 0
			end

			# Adds a torrent by URL or file path
			def self.+(url)
				self.add(:url => url)
			end

			# Gets all the torrents
			def self.all
				@unprocessed_torrents = Client.request("torrent-get", { :fields => self.fields })['arguments']['torrents']
				@unprocessed_torrents.collect { |torrent| self.new(torrent) }				
			end

			# Finds a torrent by ID
			def self.find(id)
				@unprocessed_response = Client.request("torrent-get", { :fields => self.fields }, [id])
				@torrents = @unprocessed_response['arguments']['torrents']
				if @torrents.count > 0
					return self.new(@torrents.first)
				else
					return nil
				end
			end

			# Adds a torrent by file path or URL (.torrent file's only right now)
			def self.add(options = {})
				@response = Client.request("torrent-add", :filename => options[:url])
				if @response['result'] == 'success'
					self.find(@response['arguments']['torrent-added']['id'])
				else
					nil
				end
			end

			# Starts all torrents
			def self.start!
				Client.request "torrent-start"
			end

			# Stops all torrents
			def self.stop!
				Client.request "torrent-stop"
			end

			private

			# The accessors for a torrent, the way that Transmission's RPC likes them.
			def self.fields
				@fields ||= %w(addedDate comment eta id leechers name seeders percentDone totalSize torrentFile status leftUntilDone hashString)
			end

		end
	end
end