module Photish
  module Log
    class AccessLog
      include Loggable

      def <<(message)
        log.debug message.chomp
      end
    end
  end
end
