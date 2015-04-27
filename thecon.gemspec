# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thecon/version'

Gem::Specification.new do |spec|
  spec.name          = "thecon"
  spec.version       = Thecon::VERSION
  spec.authors       = ["Tnarik Innael"]
  spec.email         = ["tnarik@lecafeautomatique.co.uk"]
  spec.summary       = %q{Attempt a connection to a certain IP (or hostname), port}
  spec.description   = %q{Simple connection checker to find out if a server is available at a certain port}
  spec.homepage      = "https://github.com/tnarik/thecon"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # development dependencies
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end