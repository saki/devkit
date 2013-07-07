require 'colorize'

module Devkit
  module GitIdentity
    class << self
      def check(identity)
        config = identity["Full Name"] == %x[git config --global user.name].chomp &&
            identity["Email"] == %x[git config --global user.email].chomp &&
            identity["Github Id"] == %x[git config --global github.user].chomp

        if config
          puts "Git config switch successfull.".green
        else
          puts "Problem switching to #{identity['Full Name']}.".red
        end
      end

      def status
        username = `git config --global user.name`
        print username
      end

      def choose(identity)
        print "Switching git config to #{identity['Full Name']}, ".blue
        $stdout.flush
        system("git config --global user.name '#{identity['Full Name']}'")
        system("git config --global user.email #{identity['Email']}")
        system("git config --global github.user #{identity['Github Id']}")

        check(identity)
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
