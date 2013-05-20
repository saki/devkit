require "yaml"
require "highline/import"

module Devkit
  class Core
    DEVELOPERS_FILE_PATH = File.expand_path('~/.developers')
    class << self
      def init!
        if check_if_developers_file_exists?
          if agree(".developers file already exist.You want to over ride existing file? (y/n)", true)
            clear_existing_developers_file
          else
            puts "No changes made to the existing file."
          end
        else
          puts "Creating .developers file in your home directory. Try devkit --add for adding more developers."
          File.new(DEVELOPERS_FILE_PATH, "w")
        end
      end

      def clean!
        if check_if_developers_file_exists? && agree("Are you sure you want to clear existing developers file? (y/n)", true)
          clear_existing_developers_file
        end
      end

      def clear_existing_developers_file
        File.truncate(DEVELOPERS_FILE_PATH, 0)
      end

      def developers
        if check_if_developers_file_exists?
          YAML.load_file(DEVELOPERS_FILE_PATH) || {}
        else
          {}
        end
      end

      def check_if_developers_file_exists?
        if File.exists?(DEVELOPERS_FILE_PATH)
          return true
        else
          return false
        end
      end
    end
  end
end
