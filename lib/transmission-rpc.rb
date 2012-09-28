require 'rest-client'
require 'active_support/core_ext'
require 'transmission-rpc/torrent'
require 'transmission-rpc/client'

module Transmission
	mattr_writer :configuration

	def self.configuration
		@configuration = Transmission::Configuration.new if @configuration.nil?
		@configuration
	end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

	def self.connected?
		Transmission::RPC::Client.connected?
	end

	# Convenience method for getting all the torrents
 	def self.torrents
 		Transmission::RPC::Torrent.all
 	end

	class Configuration
    attr_accessor :ip, :port, :path

    def initialize
			self.ip 				= "127.0.0.1"
			self.port 			= 9091
			self.path 			= "transmission/rpc"

			self
		end
  end

end
