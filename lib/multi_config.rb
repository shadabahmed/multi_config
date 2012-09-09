require "multi_config/version"

# Module for this gem
module MultiConfig
  # Checking if Rails::Railtie exists. Only then loca this railtie
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      # Railtie initializer method
      initializer 'multi_config.active_record' do
        # When active_record is loaded, only then run this. See method documentation to learn mode
        ActiveSupport.on_load :active_record do
          # Notice that full namespace is not given since search for Railtie class begin from this Module itself.
          Railtie.insert
        end
      end
    end
  end

  class Railtie
    # Include the module MultiConfig::ORMs::ActiveRecord in ActiveRecord::Base class
    def self.insert
      # Even though ActiveSupport called this method only when ActiveRecord was loaded. We are just being extra safe.
      if defined?(ActiveRecord)
        require 'multi_config/orms/active_record'
        # Calling private method :include via send. This is typically used in extensions to include a module.
        ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
      end
    end
  end
end