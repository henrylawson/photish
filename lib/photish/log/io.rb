module Photish
  module Log
    class IO
      def initialize(log, level)
        @log = log
        @level = level
      end

      def write(message)
        log.send(level, message.chomp)
      end
      alias_method :<<, :write

      private

      attr_reader :log,
                  :level
    end
  end
end
