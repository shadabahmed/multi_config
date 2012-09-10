# Setting default Active Record configs
ActiveRecord::Base.logger         = Logger.new(StringIO.new)
ActiveRecord::Base.configurations = YAML.load_file(ERB.new(File.expand_path("../config/database.yml", __FILE__)).result)

