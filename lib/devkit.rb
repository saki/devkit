$:.unshift(File.join(File.dirname(__FILE__), 'devkit'))

require "version"
require "highline/import"
require "yaml"

module Devkit
  DEVELOPERS_FILE_PATH = File.expand_path('~/.developers')
  def self.init!
    if check_if_developers_file_exists?
      if agree(".developers file already exist.You want to over ride existing file? (y/n)", true)
        self.clear_existing_developers_file
      else
        puts "No changes made to the existing file."
      end
    else
      puts "Creating .developers file in your home directory. Try devkit --add for adding more developers."
      File.new(DEVELOPERS_FILE_PATH, "w")
    end
  end

  def self.list
    puts "******************************************"
    puts "****** List of Developers ****************"
    puts "******************************************"
    puts developers.to_yaml
  end

  def self.clean!
    if self.check_if_developers_file_exists? && agree("Are you sure you want to clear existing developers file? (y/n)", true)
      self.clear_existing_developers_file
    end
  end

  def self.remove!(developer_nick_name)
    existing_developers = developers
    developer = existing_developers[developer_nick_name]
    if developer && agree("Are you sure you want to delete #{developer['Full Name']} (y/n)?", true)
      new_developers = existing_developers.reject {|dev| dev == developer_nick_name}
      self.clear_existing_developers_file
      File.open(DEVELOPERS_FILE_PATH, 'a+') do |f|
        f.write(new_developers.to_yaml)
      end
    else
      puts "Developer does not exist."
      self.list
    end
  end

  def self.switch!(developer_nick_name)
    developer = developers[developer_nick_name]
    puts developer
  end

  def self.add!
    existing_developers = developers
    nick = ask("Nick Name: ", String).to_s
    if self.developers[nick]
      puts "Developer already exists"
      self.list
    else
      new_developer = Hash.new
      new_developer[nick] = Hash.new
      new_developer[nick]["Full Name"] = ask("Full Name: ", String).to_s
      new_developer[nick]["Email"] = ask("Email: ", String).to_s
      new_developer[nick]["Github Id"] = ask("Github Id: ", String).to_s
      new_developer[nick]["SSH Identity"] = ask("SSH Identity: ", String).to_s
      self.clear_existing_developers_file
      File.open(DEVELOPERS_FILE_PATH, 'a+') do |f|
        f.write(existing_developers.merge(new_developer).to_yaml)
      end
      self.list
    end
  end

  protected

  def self.clear_existing_developers_file
    File.truncate(DEVELOPERS_FILE_PATH, 0)
  end

  def self.developers
    if check_if_developers_file_exists?
      YAML.load_file(DEVELOPERS_FILE_PATH) || {}
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
