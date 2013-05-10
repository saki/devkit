$:.unshift(File.join(File.dirname(__FILE__), 'devkit'))

require "version"

module Devkit
  def self.init!
    puts "init"
  end

  def self.list
    puts "list"
  end

  def self.clean!
    puts "clean"
  end

  def self.remove!(developer_nick_name)
    puts developer_nick_name
  end

  def self.switch!(developer_nick_name)
    puts developer_nick_name
  end

  def self.add!
    puts "add"
  end
end

