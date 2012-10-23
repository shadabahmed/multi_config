require 'spec_helper'

describe MultiConfig::ORMs::ActiveRecord::ClassMethods do
  let!(:db_config) { load_namespaced_config('database.yml') }
  let!(:other_config) { load_namespaced_config('other.yml') }
  let!(:erb_config) { load_namespaced_config('erb.yml') }

  before(:each) do
    @test_class = Class.new
    @test_class.stub_chain(:name).and_return('test_class')
    @test_class.stub(:configurations).and_return({})
    @test_class.stub(:establish_connection)
    @test_class.send(:include, MultiConfig::ORMs::ActiveRecord)
  end
  let(:test_class) { @test_class }

  describe "#config_file=" do
    context "unspecified environment" do
      before do
        Rails.stub(:env).and_return('unknown')
      end
      it "raises error when I specify a config file with environment not defined" do
        expect { test_class.config_file = 'other' }.to raise_error
      end
    end

    context "modifies class variable @@_multi_config_db_configs" do
      before do
        test_class.send(:class_variable_get, '@@_multi_config_db_configs').should == {}
        test_class.config_file = 'other'
      end
      subject { test_class.send(:class_variable_get, '@@_multi_config_db_configs') }
      it { should == {"other" => ["test_class"]} }
    end

    context "modifies .configurations" do
      before do
        test_class.should_receive(:establish_connection).once.with('other_test')
        expect {
          test_class.config_file = 'other'
        }.to change(test_class, :configurations).from({}).to(other_config)
      end
      subject { test_class.configurations }
      it { should include 'other_development' }
      it { should include 'other_test' }
    end

    context "filename without extension .yml is specified" do
      before do
        test_class.should_receive(:establish_connection).once.with('other_test')
        expect {
          test_class.config_file = 'other'
        }.to change(test_class, :configurations).from({}).to(other_config)
      end
      subject { test_class.configurations.keys }
      it { should include 'other_development' }
      it { should include 'other_test' }
    end

    context "filename with extension .yml is specified" do
      before do
        test_class.should_receive(:establish_connection).once.with('other_test')
        expect {
          test_class.config_file = 'other.yml'
        }.to change(test_class, :configurations).from({}).to(other_config)
      end
      subject { test_class.configurations.keys }
      it { should include 'other_development' }
      it { should include 'other_test' }
    end

    context "config_file= called multiple times in different models with the same file" do
      let(:first_test_class) { Class.new(test_class) }
      let(:second_test_class) { Class.new(test_class) }
      before do
        first_test_class.should_receive(:establish_connection).once.with('other_test')
        expect {
          first_test_class.config_file = 'other.yml'
        }.to change(test_class, :configurations).from({}).to(other_config)

        second_test_class.should_receive(:establish_connection).once.with('other_test')
        expect {
          second_test_class.config_file = 'other'
        }.not_to change(test_class, :configurations)

      end
      subject { second_test_class.configurations.keys }
      it { should include 'other_development' }
      it { should include 'other_test' }
    end

    context "when file is database.yml" do
      before do
        test_class.should_not_receive(:establish_connection)
        test_class.should_not_receive(:add_db_config)
        MultiConfig::ORMs::ActiveRecord::Config.should_not_receive(:path)
        MultiConfig::ORMs::ActiveRecord::Config.should_not_receive(:load)
        expect {
          test_class.config_file = 'database'
        }.not_to change(test_class, :configurations)
      end
      subject { test_class.configurations.keys }
      it { should_not include 'database_development' }
      it { should_not include 'database_test' }
    end
  end
end
