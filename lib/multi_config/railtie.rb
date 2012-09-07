require 'multi_config'

module MultiConfig
  class Railtie < Rails::Railtie
    initializer "multi_config.active_record" do |app|
      if defined? ::ActiveRecord
        require 'multi_config/orms/active_record'
        ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
      end
    end
  end
end