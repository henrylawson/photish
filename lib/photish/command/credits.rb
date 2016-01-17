module Photish
  module Command
    class Credits < Base
      def run
        puts "#{Photish::AUTHOR_NAME} <#{Photish::AUTHOR_EMAIL}>"
      end
    end
  end
end
