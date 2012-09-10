require "spec_helper"

describe UsesOtherYml do
  before do
    ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
    UsesOtherYml.config_file = 'other'
  end

  it "should be connected to the default database" do
    UsesOtherYml.connection.instance_variable_get(:@config)[:database].split('/').last.should == "other_db"
  end

  it "the @@db_configs should have entry for this class" do
    UsesOtherYml.send(:class_variable_get, :'@@db_configs').should == {"other" => ["UsesOtherYml"]}
  end
end