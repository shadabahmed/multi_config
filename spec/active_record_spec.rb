require 'spec_helper'

describe ActiveRecord::Base, "methods" do
  before do
    ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
  end

  it "should have configurations" do
    ActiveRecord::Base.configurations.should_not == {}
  end

  it "should have multi config methods" do
    ActiveRecord::Base.singleton_methods.should include(RUBY_VERSION =~ /^1\.8/ ? 'config_file=' : :'config_file=')
  end

  it "should have @@db_config class variable set" do
    ActiveRecord::Base.send(:class_variable_get, '@@db_configs').should == []
  end

end




