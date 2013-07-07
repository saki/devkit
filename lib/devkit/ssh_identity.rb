module Devkit
  module SshIdentity
    class << self
      def choose(identity)
        ssh_identity = File.join("~/.ssh/", identity['SSH Identity'])
        print "Switching ssh identity to #{File.expand_path(ssh_identity)}, "
        $stdout.flush

        if File.exists?(File.expand_path(ssh_identity))
          system("ssh-add -D")
          system("ssh-add #{ssh_identity}")
        else
          puts "#{identity["Full Name"]}'s ssh keys not found. Skipping identity switch.".red
        end

        check(identity)
      end

      def check(identity)
        ssh_identity = File.join("~/.ssh/", identity['SSH Identity'])
        ssh_identities = %x[ssh-add -l].split("\n")

        print "Checking identity, ".blue

        $stdout.flush

        if ssh_identities.length > 1
          puts "Possible amibiguity. Please double check your identity".red
        else
          puts "Using ssh identity #{File.expand_path(ssh_identity)}".green
        end
      end

      def status
        ssh_identities = %x[ssh-add -l].split("\n")
        puts ssh_identities
      end

      def drop
        system("ssh-add -D")

        ssh_identities = %x[ssh-add -l].split("\n")

        if ssh_identities.length > 1
          puts "Problem releasing existing identities. Possible amibiguity.".red
        else
          puts "Successfully dropped all the identities".green
        end
      end

    end
  end
end
