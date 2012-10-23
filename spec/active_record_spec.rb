require 'spec_helper'

describe ActiveRecord::Base, "methods" do
  before do
    ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
  end

  it "has configurations" do
    ActiveRecord::Base.configurations.should_not == {}
  end

  it "has multi config methods" do
    ActiveRecord::Base.singleton_methods.map(&:to_sym).should include(:'config_file=')
  end

  it "has @@db_config class variable set" do
    ActiveRecord::Base.send(:class_variable_get, '@@_multi_config_db_configs').should == {}
  end

end




