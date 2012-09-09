require 'spec_helper'

describe MultiConfig::ORMs::ActiveRecord do
  let!(:db_config) { load_namespaced_config('database.yml') }
  let!(:other_config) { load_namespaced_config('other.yml') }
  let!(:erb_config) { load_namespaced_config('erb.yml') }

  describe MultiConfig::ORMs::ActiveRecord::ClassMethods do
    before(:each) do
      @test_class = Class.new
      @test_class.stub_chain(:name).and_return('test_class')
      @test_class.stub(:configurations).and_return({})
      @test_class.stub(:establish_connection)
      @test_class.send(:include, MultiConfig::ORMs::ActiveRecord)
    end
    let(:test_class) { @test_class }

    describe "#config_file=" do

      it "should raise an error if file is not in present" do
        lambda { test_class.config_file = 'none' }.should raise_error
      end

      describe "should raise error in unspecified environment" do
        before do
          Rails.stub(:env).and_return('unknown')
        end
        it "should through error when I specify a config file with environment not defined" do
          lambda { test_class.config_file = 'other' }.should raise_error
        end
      end

      it "should through error when I specify invalid config file" do
        lambda { test_class.config_file = 'invalid' }.should raise_error
      end

      describe "should modify class variable @@db_configs" do
        before do
          test_class.send(:class_variable_get, '@@db_configs').should == {}
          test_class.config_file = 'other'
        end
        subject { test_class.send(:class_variable_get, '@@db_configs') }
        it { should == {"other" => ["test_class"]} }
      end

      describe "should modify .configurations" do
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

      describe "should work as expected when filename with extension .yml is specified" do
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

      describe "multiple calls for config_file= in different models should modify configurations only once" do
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

      describe "should not do anything if database.yml specified" do
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

  describe MultiConfig::ORMs::ActiveRecord::Config do
    describe '#path' do
      before do
        Rails.stub(:root).and_return('/')
      end
      subject { MultiConfig::ORMs::ActiveRecord::Config.path('other_db.yml') }
      it { should == '/config/other_db.yml' }
    end

    describe '#load' do
      it "should load yaml and erb/yaml files correctly" do
        MultiConfig::ORMs::ActiveRecord::Config.load('other.yml','other').should == other_config
        MultiConfig::ORMs::ActiveRecord::Config.load('erb.yml','erb').should == erb_config
      end
    end
  end
end