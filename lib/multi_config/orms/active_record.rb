module MultiConfig
  module ORMs
    module ActiveRecord
      def self.included(mod)
        mod.extend ClassMethods
        mod.send(:class_variable_set, :'@@db_configs', Hash.new { |h, k| h[k] = [] })
      end

      module ClassMethods
        def config_file=(file_name)
          file_name += '.yml' unless File.extname(file_name).eql? '.yml'
          unless file_name == 'database.yml'
            namespace = File.basename(file_name, '.yml')
            add_db_config(file_name, namespace)
            raise "Configuration for #{::Rails.env} environment not defined in #{Config.path file_name}" unless configurations.include? "#{namespace}_#{::Rails.env}"
            establish_connection "#{namespace}_#{::Rails.env}"
          end
        end

        private
        def add_db_config(file_name, namespace)
          db_configs = class_variable_get(:'@@db_configs')
          unless db_configs.include?(namespace)
            configurations.merge!(Config.load(file_name, namespace))
            db_configs[namespace] << name
          end
        end
      end

      module Config
        def self.path(file_name)
          File.join(Rails.root, 'config', file_name)
        end

        def self.load(file_name, namespace)
          begin
            require 'erb'
            YAML.load(ERB.new(IO.read(path(file_name))).result).inject({}) do |hash, (k, v)|
              hash["#{namespace}_#{k}"]=v
              hash
            end
          rescue Exception => exc
            raise "File #{path file_name} does not exist in config" unless File.exists?(path(file_name))
            raise "Invalid config file #{path file_name}"
          end
        end
      end
    end
  end
end