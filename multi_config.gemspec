# -*- encoding: utf-8 -*-
# This is a good way to get paths relative to current file.
lib = File.expand_path('../lib', __FILE__)
# Explicitly add to load path. Notice this is adding in the beginning so that our file is found first
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_config/version'

Gem::Specification.new do |gem|
  gem.name          = "multi_config"
  gem.version       = MultiConfig::VERSION
  gem.authors       = ["Shadab Ahmed"]
  gem.email         = [""]
  gem.description   = %q{This gem lets you specify different config file for an ActiveRecord Model}
  gem.summary       = %q{Use this gem to use multiple db config files}
  gem.homepage      = "https://github.com/shadabahmed/multi_config"

  # Load Paths. Git gives a good way to specify files while building the gem without having to put the whole list in here
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  # Added dependencies for runtime
  gem.add_runtime_dependency "rails", [">= 3.0"]

  # Added dependencies for development/test
  gem.add_development_dependency("bundler", [">= 1.0.0"])
  gem.add_development_dependency("activerecord", [">= 3.0"])
  gem.add_development_dependency("rdoc")
end
