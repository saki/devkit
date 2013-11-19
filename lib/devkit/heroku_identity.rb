require 'heroku'
require 'colorize'

module Devkit
  module HerokuIdentity
    class << self

      def status
        username = `heroku auth:whoami`
        print 'heroku: ', username
      end

      def login
        if agree("Do you want login to heroku ? (y/n)", true)
          system("heroku login")
        end
      end

      def drop
        puts "Dropping heroku account".blue
        system("heroku logout")
      end
    end
  end
end
