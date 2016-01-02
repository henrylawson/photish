module Photish
  module Log
    module Loggable
      def log
        @log ||= Setup.instance.new_logger(self.class.name)
      end
    end
  end
end
