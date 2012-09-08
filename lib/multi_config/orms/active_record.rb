module MultiConfig
  module ORMs
    module ActiveRecord
      def self.included(mod)
        mod.extend ClassMethods
        mod.send(:class_variable_set, :'@@db_configs', [])
      end

      module ClassMethods
        def config_file=(file_name)
          file_name += '.yml' unless File.extname(file_name).eql? '.yml'
          namespace = File.basename(file_name, '.yml')
          add_to_db_configs(file_name, namespace)
          unless configurations.include? "#{namespace}_#{::Rails.env}"
            raise "Configuration for #{::Rails.env} environment not defined in #{file_name}"
          end
          establish_connection "#{namespace}_#{::Rails.env}"
        end

        private

        def add_to_db_configs(file_name, namespace)
          db_configs = class_variable_get(:'@@db_configs')
          unless db_configs.include?(namespace)
            configurations.merge!(config(file_name, namespace))
            db_configs << namespace
          end
        end

        def config_path(file_name)
          File.join(Rails.root, 'config', file_name)
        end

        def config(file_name, namespace)
          begin
            config = {}
            YAML.load(ERB.new(File.read(config_path(file_name))).result).each do |k, v|
              config["#{namespace}_#{k}"] = v
            end
            config
          rescue
            raise "File #{config_path file_name} does not exist in config" unless File.exists?(config_path(file_name))
            raise "Invalid config file #{file_name}"
          end
        end
      end
    end
  end
end