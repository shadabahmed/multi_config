require 'spec_helper'
require 'rails/railtie'

describe MultiConfig::Railtie do
 describe "railtie initialization" do
    before do
      # Stub the initializer method and store the block to run later
      Rails::Railtie.stub(:initializer) { |initializer_name, &block| @railtie_initializer_block = block }
      # Stub  onload to yield directly
      ActiveSupport.stub(:on_load).and_yield
      # Remove the class definition
      MultiConfig.send(:remove_const, :Railtie)
    end
    it "should call Railtie Insert when hook is executed" do
      # Reload class definition so that class in instantiated and Railitie.initializer is called
      load 'multi_config.rb'
      MultiConfig::Railtie.should_receive(:insert).once()
      # Call the initializer block we stored earlier. We wait so that the file is completely loaded and method Railitie.insert
      # to be defined first. If we do not wait and yield directly from initializer, it would raise method not found exception
      # for Railtie.insert since we removed the constant
      @railtie_initializer_block.call
    end
  end

  describe '#insert' do
    it "should call ActiveRecord::Base.include" do
      ActiveRecord::Base.should_receive(:send).with(:include, MultiConfig::ORMs::ActiveRecord).once()
      MultiConfig::Railtie.insert
    end
  end
end