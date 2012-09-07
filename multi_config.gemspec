# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_config/version'

Gem::Specification.new do |gem|
  gem.name          = "multi_config"
  gem.version       = MultiConfig::VERSION
  gem.authors       = ["Shadab Ahmed"]
  gem.email         = [""]
  gem.description   = %q{This gem lets you specify different config file for an ActiveRecord Model}
  gem.summary       = %q{Use this gem to use multiple db config files}
  gem.homepage      = "https://github.com/shadykiller/multi_config"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end