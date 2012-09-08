require 'spec_helper'

describe MultiConfig::ORMs::ActiveRecord do
  before do
    ActiveRecord::Base.send(:include, MultiConfig::ORMs::ActiveRecord)
  end

  describe "#config_file=" do

    it "should raise an error if file is not in present" do
      lambda{ActiveRecord::Base.config_file = 'none'}.should raise_error
    end

    describe "should set class variable @@db_config" do
      before do
        ActiveRecord::Base.config_file = 'other'
      end
      subject {ActiveRecord::Base.send(:class_variable_get, '@@db_configs')}
      it{should include 'other'}
    end

    describe "should add to config" do
      before do
        ActiveRecord.stub(:configurations).and_return([])
        ActiveRecord::Base.config_file = 'other'
      end
      subject {ActiveRecord::Base.configurations.keys}
      it{should include 'other_development'}
      it{should include 'other_test'}
    end

    describe "should add to config when filename with .yml specified" do
      before do
        ActiveRecord.stub(:configurations).and_return([])
        ActiveRecord::Base.config_file = 'other.yml'
      end
      subject {ActiveRecord::Base.configurations.keys}
      it{should include 'other_development'}
      it{should include 'other_test'}
    end

    describe "should add to config when filename with .yml specified" do
      before do
        ActiveRecord.stub(:configurations).and_return([])
        ActiveRecord::Base.should_receive(:establish_connection).with('other_test')
        ActiveRecord::Base.should_receive(:add_to_db_configs).with('other.yml', 'other')
        ActiveRecord::Base.config_file = 'other'
      end
      subject {ActiveRecord::Base.configurations.keys}
      it{should include 'other_development'}
      it{should include 'other_test'}
    end

    describe "should raise error in unspecified environment" do
      before do
        Rails.stub(:env).and_return('unknown')
      end
      it "should through error when i try to specify config file" do
        lambda{ActiveRecord::Base.config_file = 'other'}.should raise_error
      end
    end

  end

end