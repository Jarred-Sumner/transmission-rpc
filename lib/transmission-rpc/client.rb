module Transmission
	module RPC
		# This communicates with Transmission's RPC server. Transmission's RPC is just an HTTP server with a JSON API
		# It implements part of the [RPC 1.7.X spec](https://trac.transmissionbt.com/browser/branches/1.7x/doc/rpc-spec.txt)
		module Client
			API_VERSION = '1.7'

			# Checks if we're connected to the Trasmission Daemon.
			# If you're having problems, make sure you have the Transmission Daemon installed and then try running transmission-daemon -f in your shell
			def self.connected?
				request("session-get")
			end

			# Sends out a request to Transmission's RPC server
			# If you're curious about the formatting, [read this](https://trac.transmissionbt.com/browser/branches/1.7x/doc/rpc-spec.txt) 
			def self.request(method, arguments = {}, ids = [])
				arguments = self.add_ids(arguments, ids) if ids.present?
				begin
					@response = RestClient.post(self.url, { :method => method, :arguments => arguments }.to_json, :x_transmission_session_id => self.session_id) do |response, request, result, &block|
						case response.code
						when 200
							return JSON.parse(@response.body)
						# Wrong session ID, set session ID to nil and try again
						when 409
							@session_id = nil
							self.request(method, arguments, ids)
						end
					end
				rescue
					puts "Couldn't connect to Transmission. Is Transmission running at http://#{Transmission.configuration.ip}:#{Transmission.configuration.port}?"
					return false
				end
			end

			private

			# Transmission's RPC requires a session ID. When you do a GET on /transmission/rpc then it gives you a 409 and a header that contains the session ID.
			# This gets that session ID
			def self.session_id
				return @session_id unless @session_id.blank?
				begin
					RestClient.get(self.url)
				rescue => e
					return @session_id = e.response.headers[:x_transmission_session_id]
				end
			end

			# Utility method for adding IDs to the arguments hash, even if it doesn't exist
			def self.add_ids(arguments, ids)
				arguments = {} if arguments.nil?
				arguments[:ids] = ids
				arguments
			end

			# URL to current Transmission Daemon
			def self.url
				"http://#{Transmission.configuration.ip}:#{Transmission.configuration.port}/#{Transmission.configuration.path}"
			end

		end
	end
end