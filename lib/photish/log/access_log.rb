module Photish
  module Log
    class AccessLog
      def initialize
        @log = Logging.logger[self]
      end

      def <<(message)
        log.info message.chomp
      end

      private

      attr_reader :log
    end
  end
end
