# Transmission::RPC

A simplistic Transmission RPC client for Ruby. It implements part of [RPC 1.7.x](https://trac.transmissionbt.com/browser/branches/1.7x/doc/rpc-spec.txt).

You can:

	- Add a torrent by URL or file path
	- Start a torrent
	- Stop a torrent
	- Get all torrents
	- Delete torrents from Transmission and from disk

## Installation

Add this line to your application's Gemfile:

	gem 'transmission-rpc'

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install transmission-rpc

It depends on ```transmission-daemon```. Install it from homebrew:
		
	$ brew install transmission

```transmission-daemon``` must be running, run it like so:

	$ transmission-daemon

## Usage

To add a torrent by URL or file path:

	Transmission::RPC::Torrent + "http://example.com/url/to/torrent.torrent"

To start all torrents:

	Transmission::RPC::Torrent.start!

To stop all torrents:

	Transmission::RPC::Torrent.stop!

To get all torrents:

	Transmission.torrents

To start a specific torrent:

	Transmission.torrents.first.start!

To stop a specific torrent:

	Transmission.torrents.first.stop!

To delete a torrent:

	Transmission.torrents.first.delete!

To delete a torrent and delete the contents from disk:

	Transmission.torrents.first.delete!(true)


