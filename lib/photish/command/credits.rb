module Photish
  module Command
    class Credits < Base
      def run
        puts "#{Photish::CONTACT}"
      end
    end
  end
end
