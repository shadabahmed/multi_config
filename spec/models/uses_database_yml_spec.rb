require "spec_helper"

describe UsesDatabaseYml do
  before do
    ActiveRecord::Base.send(:extend, MultiConfig::ORMs::ActiveRecord)
    UsesDatabaseYml.establish_connection
  end

  it "connects to the alternate database" do
    UsesDatabaseYml.connection.instance_variable_get(:@config)[:database].split('/').last.should == "db"
  end
end