module Photish
  module Log
    def log(message)
      puts "#{Time.now.iso8601} => #{message}"
    end
  end
end
