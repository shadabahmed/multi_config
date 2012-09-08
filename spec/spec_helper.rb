require 'rubygems'
require 'bundler/setup'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec'

require 'rails'
require 'active_record'
require 'multi_config/orms/active_record'

require 'spec/fixtures/models'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "spec/support/**/*.rb")].each {|f| require f}

FileUtils.mkdir_p "#{Dir.pwd}/tmp"
ActiveRecord::Base.logger         = Logger.new(StringIO.new)
ActiveRecord::Base.configurations = YAML.load_file(File.join("spec", "fixtures", "config", "database.yml"))

def set_rails_root
  Rails.stub(:env).and_return('test')
  Rails.stub(:root).and_return(File.expand_path(File.join(File.dirname(__FILE__),'fixtures')))
end

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = 'random'
  config.before(:each) do
    #extend RailsRoot
    set_rails_root
  end
end
