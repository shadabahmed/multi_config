# Loads a namespaced config. Similar to the load method in MultiConfig::ORMs::ActiveRecord::Config.path method
def load_namespaced_config(file)
  namespace = File.basename(file, File.extname(file))
  config = YAML.load(ERB.new(IO.read(File.expand_path("../config/#{file}", __FILE__))).result)
  config.inject({}){|h,(k,v)| h["#{namespace}_#{k}"]=v;h}
end