require "multi_config/version"

module MultiConfig
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'multi_config.active_record' do
        ActiveSupport.on_load :active_record do
          MultiConfig::Railtie.insert
        end
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        require 'multi_config/orms/active_record'
        ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
      end
    end
  end
end