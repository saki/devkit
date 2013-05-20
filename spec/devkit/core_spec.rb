require 'spec_helper'

describe Devkit::Core do
  before do
    #Devkit::Core.clean!
    #Devkit::Core.init!
  end

  context 'developers config file' do
    it 'developers config file path should be set' do
      Devkit::Core::DEVELOPERS_FILE_PATH.should_not be_nil
    end

    it 'developers config file should be .developers' do
      Devkit::Core::DEVELOPERS_FILE_PATH.should == File.expand_path('~/.developers')
    end
  end


#@TODO : Test it with a stub DEVELOPERS_FILE_PATH value
describe do
  context '.init!' do
    it 'should create .developers file if does not exist' do
      File.exists?(File.expand_path('~/.developers')).should be_true
    end
  end
end

  describe '.clean!' do
    it 'should clean existing developers file' do
        File.size(File.expand_path('~/.developers')).should equal(0)
    end
  end

  describe '.developers' do
    it 'should return list of existing developers' do
      Devkit::Core::developers.is_a?(Hash).should be_true
    end
  end

  describe '.check_if_developers_file_exists?' do
    it 'should check if developers file exists' do
      File.exists?(File.expand_path('~/.developers')).should be_true
    end
  end
end
