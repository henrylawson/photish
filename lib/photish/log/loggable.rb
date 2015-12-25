module Photish
  module Log
    module Loggable
      def log
        @log ||= LogSetup.instance.new_logger(self.class.name)
      end
    end
  end
end
