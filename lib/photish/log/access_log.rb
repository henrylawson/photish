module Photish
  module Log
    class AccessLog
      include Loggable

      def <<(message)
        log.info message.chomp
      end

      private

      attr_reader :log
    end
  end
end
