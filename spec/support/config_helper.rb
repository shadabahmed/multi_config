def load_namespaced_config(file)
  namespace = File.basename(file, File.extname(file))
  config = YAML.load(ERB.new(File.read(File.expand_path("../config/#{file}", __FILE__))).result)
  config.inject({}){|h,(k,v)| h["#{namespace}_#{k}"]=v;h}
end