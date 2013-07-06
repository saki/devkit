$:.unshift(File.join(File.dirname(__FILE__)))

require 'devkit/core'
require 'devkit/developer'
require 'devkit/git_config'
require 'devkit/ssh_identity'
require 'devkit/version'

module Devkit
  EXPIRY_TIME = 14400

  class << self
    def bin_path
      %x[which devkit].chomp
    end
  end
end
