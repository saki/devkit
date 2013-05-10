$:.unshift(File.join(File.dirname(__FILE__), 'devkit'))

require 'version'
require 'highline'
require 'yaml'

module Devkit
  DEVELOPERS_FILE_PATH = File.expand_path('~/.developers')

  # Check if .developers file exists in user directory
  # Else create an empty .developers file
  # Prompt for adding new developers
  def self.init!
    if check_if_developers_file_exists?
      puts "developer file exists."
      #Prompt user that the file already exists and if the user really want to start over ask him to user devkit --clean
    else
      puts "developer file does not exist."
      #Create file
      #Promt user to add more developers      
    end
  end

  def self.list 
    puts developers.to_yaml  
  end

  def self.clean!
    #Prompt the user to make sure he actually want to delete everything
    #if yes delete everything
    #if no exit
    puts 'clean'
  end

  def self.remove!(developer_nick_name)
    developer = developers[developer_nick_name]
    puts developer
    
    #Prompt the user to make sure he actually want to delete developer
    #if yes delete developer from .developers
    #if no exit
  end

  def self.switch!(developer_nick_name)
    developer = developers[developer_nick_name]
    puts developer
  end

  def self.add!
    puts 'add'
  end

  protected

  def self.developers
    if check_if_developers_file_exists? 
      YAML.load_file(DEVELOPERS_FILE_PATH)
    else
      {}         
    end 
  end

  def self.check_if_developers_file_exists?
    if File.exists?(DEVELOPERS_FILE_PATH)
      return true
    else
      return false
    end
  end
end

