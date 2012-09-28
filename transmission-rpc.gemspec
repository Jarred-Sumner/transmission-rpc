# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "transmission-rpc"
  gem.version       = '0.1.0'
  gem.authors       = ["Jarred Sumner"]
  gem.email         = ["jarred@jarredsumner.com"]
  gem.description   = %q{A simple Transmission RPC client for Ruby.}
  gem.summary       = %q{A simple Transmission RPC client for Ruby. It can add torrents, start/stop torrents, remove them to/from Transmission.}
  gem.homepage      = "https://github.com/jarred-sumner/transmission-rpc"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rest-client"
  gem.add_dependency "json"
  gem.add_dependency "activesupport"
end
