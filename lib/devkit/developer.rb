require 'highline/import'
require 'colorize'

module Devkit
  class Developer
    attr_accessor :full_name, :nick_name, :email, :github_id, :ssh_identity
    class << self
      def list
        puts Devkit::Core.developers.to_yaml
      end

      def remove!(developer_nick_name)
        existing_developers = Devkit::Core.developers
        developer = existing_developers[developer_nick_name]
        if developer && agree("Are you sure you want to delete #{developer['Full Name']} (y/n)?", true)
          new_developers = existing_developers.reject { |dev| dev == developer_nick_name }
          Devkit::Core.clear_existing_developers_file
          File.open(Devkit::Core::DEVELOPERS_FILE_PATH, 'a+') do |f|
            f.write(new_developers.to_yaml)
          end
        else
          puts "#{developer_nick_name} does not exist in .developers list"
          #self.list
        end
      end

      def choose!(developer_nick_name)
        developer = Devkit::Core.developers[developer_nick_name]
        Devkit::GitConfig.choose(developer)
        Devkit::SshIdentity.choose(developer)
        expire_in(developer['Expires In'])
      end

      def drop!
        Devkit::GitConfig.drop
        Devkit::SshIdentity.drop
      end

      def expire_in(time)
        time ||= Devkit::EXPIRY_TIME
        puts "Setting the identity to expire in #{time} seconds"
        %w(sleep #{time} && #{Devkit.bin_path} --drop &)
      end

      def add!
        existing_developers = Devkit::Core.developers
        nick = ask("Nick Name: ", String).to_s

        if Devkit::Core.developers[nick]
          puts "Developer already exists"
          list
        else
          new_developer = Hash.new
          new_developer[nick] = Hash.new
          new_developer[nick]["Full Name"] = ask("Full Name: ", String).to_s
          new_developer[nick]["Email"] = ask("Email: ", String).to_s
          new_developer[nick]["Github Id"] = ask("Github Id: ", String).to_s
          new_developer[nick]["SSH Identity"] = ask("SSH Identity: ", String).to_s
          new_developer[nick]["Expires In"] = EXPIRY_TIME

          Devkit::Core.clear_existing_developers_file

          File.open(Devkit::Core::DEVELOPERS_FILE_PATH, 'a+') do |f|
            f.write(existing_developers.merge(new_developer).to_yaml)
          end

          list
        end
      end
    end
  end
end
