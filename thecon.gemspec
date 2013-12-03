# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thecon/version'

Gem::Specification.new do |gem|
  gem.name          = "thecon"
  gem.version       = Thecon::VERSION
  gem.authors       = ["tnarik"]
  gem.email         = ["tnarik@gmail.com"]
  gem.description   = %q{Simple connection checker to find out if a server is available at a certain port}
  gem.summary       = %q{Attempt a connection to a certain IP (or hostname), port}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
