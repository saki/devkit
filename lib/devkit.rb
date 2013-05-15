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
      new_developers = existing_developers.reject { |dev| dev == developer_nick_name }
      self.clear_existing_developers_file
      File.open(DEVELOPERS_FILE_PATH, 'a+') do |f|
        f.write(new_developers.to_yaml)
      end
    else
      puts "#{developer_nick_name} does not exist in .developers list"
      #self.list
    end
  end

  def self.switch!(developer_nick_name)
    developer = developers[developer_nick_name]
    switch_git_config(developer)
    switch_identity(developer)
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

  def self.switch_git_config(developer)
    print "Switching git config to #{developer['Full Name']}, "
    $stdout.flush
    system("git config --global user.name '#{developer['Full Name']}'")
    system("git config --global user.email #{developer['Email']}")
    system("git config --global github.user #{developer['Github Id']}")

    check_git_config(developer)
  end

  def self.check_git_config(developer)
    check = developer["Full Name"] == %x[git config --global user.name].chomp &&
        developer["Email"] == %x[git config --global user.email].chomp &&
        developer["Github Id"] == %x[git config --global github.user].chomp

    if check
      puts "Switch successfull."
    else
      puts "Problem switching to #{developer['Full Name']}."
    end
  end

  def self.switch_identity(developer)
    identity = File.join("~/.ssh/", developer['SSH Identity'])
    print "Switching ssh identity to #{File.expand_path(identity)}, "
    $stdout.flush

    if File.exists?(File.expand_path(identity))
      system("ssh-add -D")
      system("ssh-add #{identity}")
      check_identity(developer)
    else
      puts "#{developer["Full Name"]}'s ssh keys not found. Skipping identity switch."
    end
  end

  def self.check_identity(developer)
    identity = File.join("~/.ssh/", developer['SSH Identity'])
    identities = %x[ssh-add -l].split("\n")

    print "Checking identity, "

    $stdout.flush

    if identities.length > 1
      puts "Problem releasing existing identities. Possible amibiguity."
    else
      puts "Successfully switched ssh identity to #{File.expand_path(identity)}"
    end
  end
end
