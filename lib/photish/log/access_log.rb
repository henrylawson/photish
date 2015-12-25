module Photish
  module Log
    class AccessLog
      include Loggable

      def <<(message)
        log.info message.chomp
      end
    end
  end
end
