module Devkit
  module SshIdentity
    class << self
      def switch(developer)
        identity = File.join("~/.ssh/", developer['SSH Identity'])
        print "Switching ssh identity to #{File.expand_path(identity)}, "
        $stdout.flush

        if File.exists?(File.expand_path(identity))
          system("ssh-add -D")
          system("ssh-add #{identity}")
        else
          puts "#{developer["Full Name"]}'s ssh keys not found. Skipping identity switch.".red
        end

        check(developer)
      end

      def check(developer)
        identity = File.join("~/.ssh/", developer['SSH Identity'])
        identities = %x[ssh-add -l].split("\n")

        print "Checking identity, ".blue

        $stdout.flush

        if identities.length > 1
          puts "Possible amibiguity. Please double check your identity".red
        else
          puts "Using ssh identity #{File.expand_path(identity)}".green
        end
      end

      def drop
        system("ssh-add -D")

        identities = %x[ssh-add -l].split("\n")

        if identities.length > 1
          puts "Problem releasing existing identities. Possible amibiguity.".red
        else
          puts "Successfully dropped all the identities".green
        end
      end

      def status

      end
    end
  end
end
