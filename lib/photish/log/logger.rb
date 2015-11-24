module Photish
  module Log
    module Logger
      def log(message)
        puts "#{Time.now.iso8601} => #{message}"
      end
    end
  end
end
