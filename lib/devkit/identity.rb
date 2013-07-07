require 'highline/import'
require 'colorize'

module Devkit
  class Identity
    attr_accessor :full_name, :email, :github_id, :ssh_identity

    class << self
      def list
        puts Devkit::Core.identities.to_yaml
      end

      def remove!(nick_name)
        existing_identities = Devkit::Core.identities
        identity = existing_identities[nick_name]
        if identity && agree("Are you sure you want to delete #{identity['Full Name']} (y/n)?", true)
          new_identities = existing_identities.reject { |dev| dev == nick_name }
          Devkit::Core.clear_existing_devkit_file
          File.open(Devkit::DEVKIT_FILE_PATH, 'a+') do |f|
            f.write(new_identities.to_yaml)
          end
        else
          puts "#{nick_name} does not exist in .devkit identities"
          #self.list
        end
      end

      def choose!(nick_name)
        identity = Devkit::Core.identities[nick_name]
        if identity
          Devkit::GitIdentity.choose(identity)
          Devkit::SshIdentity.choose(identity)
          expire_in(identity['Expires In'])
        else
          puts "#{nick_name} does not exist. Please try devkit --list to double check."
        end
      end

      def drop!
        Devkit::GitIdentity.drop
        Devkit::SshIdentity.drop
      end

      def expire_in(time)
        time ||= Devkit::EXPIRY_TIME
        command = "sleep #{time} && #{Devkit.bin_path} --drop&"
        puts "Setting the identity to expire in #{time} seconds"
        system(command)
      end

      def add!
        existing_identities = Devkit::Core.identities
        nick_name = ask("Nick Name: ", String).to_s

        if Devkit::Core.identities[nick_name]
          puts "identity already exists"
          list
        else
          new_identity = Hash.new
          new_identity[nick_name] = Hash.new
          new_identity[nick_name]["Full Name"] = ask("Full Name: ", String).to_s
          new_identity[nick_name]["Email"] = ask("Email: ", String).to_s
          new_identity[nick_name]["Github Id"] = ask("Github Id: ", String).to_s
          new_identity[nick_name]["SSH Identity"] = ask("SSH Identity: ", String).to_s
          new_identity[nick_name]["Expires In"] = EXPIRY_TIME

          Devkit::Core.clear_existing_devkit_file

          File.open(Devkit::DEVKIT_FILE_PATH, 'a+') do |f|
            f.write(existing_identities.merge(new_identity).to_yaml)
          end

          list
        end
      end
    end
  end
end
