module Photish
  module Log
    module Loggable
      def log
        @log ||= Logging.logger[self]
      end
    end
  end
end
