# Transmission::RPC

A simplistic Transmission RPC client for Ruby. It implements part of [RPC 1.7.x](https://trac.transmissionbt.com/browser/branches/1.7x/doc/rpc-spec.txt).

You can:

* Add a torrent by URL or file path
* Start a torrent
* Stop a torrent
* Get all torrents
* Delete torrents from Transmission and from disk

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transmission-rpc'
```

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

```ruby
Transmission::RPC::Torrent + "http://example.com/url/to/torrent.torrent"
```

To add a torrent by metainfo:
```ruby
require 'base64'
f = File.open "moo.torrent"
Transmission::RPC::Torrent.add({:metainfo => Base64.strict_encode(f.read)})
```

To set specific options for torrent file:
```ruby
Transmission::RPC::Torrent.add({
  :filename => "http://example.com/url/to/torrent.torrent",
  :download_dir => "path/to/downloaded/files",
  :paused => true
})
```

To start all torrents:

```ruby
Transmission::RPC::Torrent.start!
```

To stop all torrents:

```ruby
Transmission::RPC::Torrent.stop!
```

To get all torrents:

```ruby
Transmission.torrents
```

To start a specific torrent:

```ruby
Transmission.torrents.first.start!
```

To stop a specific torrent:

```ruby
Transmission.torrents.first.stop!
```

To delete a torrent:

```ruby
Transmission.torrents.first.delete!
```

To delete a torrent and delete the contents from disk:

```ruby
Transmission.torrents.first.delete!(true)
```

