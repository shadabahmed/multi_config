def set_rails_conf
  Rails.stub(:env).and_return('test')
  Rails.stub(:root).and_return(File.expand_path('../', __FILE__))
end
