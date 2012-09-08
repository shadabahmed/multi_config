require 'spec_helper'

describe ActiveRecord::Base, "methods" do
  before do
    ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
  end

  it "should have configurations" do
    ActiveRecord::Base.configurations.should_not == {}
  end

  it "should have multi config methods" do
    ActiveRecord::Base.singleton_methods.should include('config_file=')
  end
end




