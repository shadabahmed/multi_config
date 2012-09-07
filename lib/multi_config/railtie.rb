require 'multi_config'

module MultiConfig
  class Railtie < Rails::Railtie
    initializer "multi_config.active_record" do |app|
      if defined? ::ActiveRecord
        require 'multi_config/active_record'
        ActiveRecord::Base.send(:extend, MultiConfig::ORMs::ActiveRecord)
      end
    end
  end
end