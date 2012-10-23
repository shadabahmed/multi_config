require "spec_helper"

describe UsesOtherYml do
  before do
    ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
    UsesOtherYml.config_file = 'other'
  end

  it "connects to the default database" do
    UsesOtherYml.connection.instance_variable_get(:@config)[:database].split('/').last.should == "other_db"
  end

  it "stores an entry in @@_multi_config_db_configs" do
    UsesOtherYml.send(:class_variable_get, :'@@_multi_config_db_configs').should == {"other" => ["UsesOtherYml"]}
  end
end