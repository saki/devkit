require 'colorize'

module Devkit
  module GitConfig
    class << self
      def check(developer)
        config = developer["Full Name"] == %x[git config --global user.name].chomp &&
            developer["Email"] == %x[git config --global user.email].chomp &&
            developer["Github Id"] == %x[git config --global github.user].chomp

        if config
          puts "Git config switch successfull.".green
        else
          puts "Problem switching to #{developer['Full Name']}.".red
        end
      end

      def status
        username = `git config --global user.name`
        print username
      end

      def switch(developer)
        print "Switching git config to #{developer['Full Name']}, ".blue
        $stdout.flush
        system("git config --global user.name '#{developer['Full Name']}'")
        system("git config --global user.email #{developer['Email']}")
        system("git config --global github.user #{developer['Github Id']}")

        check(developer)
      end

      def drop
        puts "Dropping git config".blue
        system("git config --global --unset-all user.name")
        system("git config --global --unset-all user.email")
        system("git config --global --unset-all github.user")
      end
    end
  end
end
