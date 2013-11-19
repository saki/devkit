require "yaml"
require "highline/import"

module Devkit
  class Core
    class << self
      def init!
        if check_if_devkit_file_exists?
          if agree(".devkit file already exist.You want to over ride existing file? (y/n)", true)
            clear_existing_devkit_file
            puts "Cleared existing identities in .devkit file"
          else
            puts "No changes made to the existing file."
          end
        else
          puts "Creating .devkit file in your home directory. Try devkit --add for adding more identities to devkit."
          File.new(DEVKIT_FILE_PATH, "w")
        end
      end

      def purge!
        if check_if_devkit_file_exists? && agree("Are you sure you want to clear existing devkit file? (y/n)", true)
          clear_existing_devkit_file
        end
      end

      def status
        Devkit::GitIdentity::status
        Devkit::HerokuIdentity::status
        Devkit::SshIdentity::status
      end

      def clear_existing_devkit_file
        File.truncate(DEVKIT_FILE_PATH, 0)
      end

      def identities
        if check_if_devkit_file_exists?
          YAML.load_file(DEVKIT_FILE_PATH) || {}
        else
          {}
        end
      end

      def check_if_devkit_file_exists?
        if File.exists?(DEVKIT_FILE_PATH)
          return true
        else
          return false
        end
      end
    end
  end
end
