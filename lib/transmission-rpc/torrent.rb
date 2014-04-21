module Transmission
  module RPC
    # A nice wrapper around Transmission's RPC
    class Torrent
      ATTRIBUTES = {
        :id                 => 'id',
        :date_added         => 'addedDate', 
        :comment            => 'comment', 
        :description        => 'description', 
        :download_directory => 'downloadDir',
        :date_done          => 'doneDate', 
        :eta                => 'eta', 
        :files              => 'files', 
        :hash               => 'hashString', 
        :leechers           => 'leechers',
        :bytes_left         => 'leftUntilDone', 
        :name               => 'name',
        :percent_done       => 'percentDone', 
        :download_speed     => 'rateDownload', 
        :seeders            => 'seeders',
        :seed_ratio_limit   => 'seedRatioLimit',
        :size               => 'sizeWhenDone', 
        :status             => 'status', 
        :torrent_file       => 'torrentFile', 
        :total_size         => 'totalSize', 
        :upload_limit       => 'uploadLimit',
        :upload_limited     => 'uploadLimited',
        :upload_ratio       => 'uploadRatio'
      } 

      ATTRIBUTES.each {|k,v| attr_accessor k}
      include Transmission::RPC
      
      def initialize(options = {})
        ATTRIBUTES.each do |k,v|
          self.send("#{k}=", options[v])
        end
        self.date_added     = Time.new(1970) + options['addedDate']
        self.date_done     = Time.new(1970) + options['doneDate']
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
        @response = nil
        if options[:metainfo]
          @response = Client.request("torrent-add", :metainfo => options[:metainfo])
        else
          @response = Client.request("torrent-add", :filename => options[:url])
        end

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
        @fields ||= ATTRIBUTES.values
      end

    end
  end
end
