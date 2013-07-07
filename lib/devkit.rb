$:.unshift(File.join(File.dirname(__FILE__)))

require 'devkit/core'
require 'devkit/identity'
require 'devkit/git_identity'
require 'devkit/ssh_identity'
require 'devkit/version'

module Devkit
  EXPIRY_TIME = 14400
  DEVKIT_FILE_PATH = File.expand_path('~/.devkit')

  class << self
    def bin_path
      %x[which devkit].chomp
    end
  end
end
