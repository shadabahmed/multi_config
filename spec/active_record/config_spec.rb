require 'spec_helper'

describe MultiConfig::ORMs::ActiveRecord::Config do
  describe '#path' do
    before do
      Rails.stub(:root).and_return('/')
    end
    subject { MultiConfig::ORMs::ActiveRecord::Config.path('other_db.yml') }
    it { should == '/config/other_db.yml' }
  end

  describe '#load' do
    let!(:db_config) { load_namespaced_config('database.yml') }
    let!(:other_config) { load_namespaced_config('other.yml') }
    let!(:erb_config) { load_namespaced_config('erb.yml') }

    it "should load yaml and erb/yaml files correctly" do
      MultiConfig::ORMs::ActiveRecord::Config.load('other.yml', 'other').should == other_config
      MultiConfig::ORMs::ActiveRecord::Config.load('erb.yml', 'erb').should == erb_config
    end

    it "should raise an error if file is not in present" do
      lambda { MultiConfig::ORMs::ActiveRecord::Config.load('none.yml', 'none') }.should raise_error(RuntimeError)
    end

    it "should raise an error when I specify invalid config file" do
      lambda { MultiConfig::ORMs::ActiveRecord::Config.load('invalid.yml', 'invalid') }.should raise_error(RuntimeError)
    end
  end
end