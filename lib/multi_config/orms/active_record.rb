module MultiConfig
  module ORMs
    module ActiveRecord
      def config_file=(file_name)
        namespace = File.basename(file_name, '.yml')
        @@db_configs ||= []
        unless @@db_configs.include?(namespace)
          configurations.merge!(config(file_name,namespace))
          @@db_configs << namespace
        end
        unless configurations.include? "#{namespace}_#{::Rails.env}"
          raise "#{::Rails.env} config not defined in #{file_name}"
        end
        establish_connection "#{namespace}_#{::Rails.env}"
      end

      private

      def config_path(file_name)
        file_name = File.join(file_name, '.yml') unless File.extname(file_name).eql? '.yml'
        File.join(Rails.root, 'config', file_name)
      end

      def config(file_name, namespace)
        begin
          config = {}
          YAML.load(ERB.new(File.read(config_path(file_name))).result).each do |k,v|
            config["#{namespace}_#{k}"] = v
          end
        rescue
          raise "File #{file_name} does not exist in config" unless File.exists?(file)
          raise "Invalid config file #{file_name}"
        end
      end

    end
  end
end