require "spec/spec_helper"

describe UsesOtherYml do
  before do
    ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
    UsesOtherYml.config_file = 'other'
  end

  it "should be connected to the default database" do
    UsesOtherYml.connection.instance_variable_get(:@config)[:database].split('/').last.should == "other_db"
  end
end