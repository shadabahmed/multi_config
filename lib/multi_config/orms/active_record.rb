module MultiConfig
  # This module encloses implementations for multiple ORMs
  module ORMs
    # Implementation for the ActiveRecord ORM
    module ActiveRecord
      # Method called when the module is included.
      # * +mod+ - Name of the class including this module.
      # Calls mod.extend with param ClassMethods so that methods in ClassMethods module become class methods of the class.
      def self.included(mod)
        mod.extend ClassMethods
        # Setting @@_multi_config_db_configs in the including class. This will help us keep track of database configuration files already included
        mod.send(:class_variable_set, :'@@_multi_config_db_configs', Hash.new { |h, k| h[k] = [] })
      end

      # This `acts_as` style extension provides the capabilities for using multiple database configuration files. Any
      # model can specify what database config file to use by using a Rails 3.2 style self.config_file= method.
      #
      # Example:
      #
      #   class DifferentTable < ActiveRecord::Base
      #     self.config_file = 'other_db'
      #   end
      #
      #   In config/other_db.yml
      #
      #   development: &development
      #     database: db/other_db
      #     host: localhost
      #     adapter: sqlite3
      #
      #   test:
      #     <<: *development
      module ClassMethods
        # Use the specified config file for database. You can specify file without .yml extension. If you specify database.yml or
        # database, it will not have any effect since that is loaded by default.
        def config_file=(file_name)
          file_name += '.yml' unless File.extname(file_name).eql? '.yml'
          # Load config file if it is not database.yml
          unless file_name == 'database.yml'
            namespace = File.basename(file_name, '.yml')
            # Update active_record configurations hash
            add_db_config(file_name, namespace)
            # Raise error if the config file does not have the current environment
            raise "Configuration for #{::Rails.env} environment not defined in #{Config.path file_name}" unless configurations.include? "#{namespace}_#{::Rails.env}"
            # Establish connection. This is the only way I found to different database config. Will try to find alternative
            establish_connection :"#{namespace}_#{::Rails.env}"
          end
        end

        private
        # Adds namespaced database configuration to configurations hash.
        # * +file_name+ - file name of the database config file
        # * +namespace+ - this is the basename of the file. e.g. other_db when file is other_db.yml. Any other can be specified
        # If a db config file has been added to the configurations once with a specific namespace, it will not be loaded again for
        # same namespace. For .e.g. Models A and B specify config file 'other_db', then other_db.yml will be read only once.
        def add_db_config(file_name, namespace)
          # Read class var from the including class
          db_configs = class_variable_get(:'@@_multi_config_db_configs')

          # Don't do anything if the namespace has already been added
          unless db_configs.include?(namespace)
            configurations.merge!(Config.load(file_name, namespace))
            # Add class name in db_configs. This is to keep track of models that have specified a particular db config file.
            db_configs[namespace] << name
          end
        end
      end

      # Defines helper methods to be used the the extension. Since this is in the enclosing module for ClassMethods Module.
      # This will be searched first when Config is referenced. The Ruby Programming Language - Page 276
      module Config

        # Returns the absolute path for the file specified. The file is supposed to be located in the config folder.
        def self.path(file_name)
          File.join(Rails.root, 'config', file_name)
        end

        # Load a yaml file and modify the keys by appending <tt><namespace>_</tt> string in the keys. For e.g. if a yaml
        # file with namespace other_db is loaded with environments test and development, the returned hash from this method
        # would contain keys 'other_db_test' and 'other_db_development'.
        def self.load(file_name, namespace)
          begin
            require 'erb'
            YAML.load(ERB.new(IO.read(path(file_name))).result).inject({}) do |hash, (k, v)|
              hash["#{namespace}_#{k}"] = v
              hash
            end
          # ruby 1.9 raises SyntaxError exception which is not subclass of
          rescue StandardError, SyntaxError
            raise "File #{path file_name} does not exist in config" unless File.exists?(path(file_name))
            raise "Invalid config file #{path file_name}"
          end
        end
      end
    end
  end
end
