require 'colorize'

module Photish
  module Log
    module Logger
      def log(message)
        puts "#{Time.now.iso8601.colorize(:blue)} => #{message.to_s.colorize(:green)}"
      end
    end
  end
end
