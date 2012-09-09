# Stub out rails root method.
def set_rails_conf
  Rails.stub(:root).and_return(File.expand_path('../', __FILE__))
end
