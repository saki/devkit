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

  describe '.init!' do
    it 'should create .developers file if does not exist'
  end

  describe '.clean!' do
    it 'should clean existing developers file'
  end

  describe '.developers' do
    it 'should return list of existing developers'
  end

  describe '.check_if_developers_file_exists?' do
    it 'should check if developers file exists'
  end
end
