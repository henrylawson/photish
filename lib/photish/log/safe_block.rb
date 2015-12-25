module Photish
  module Log
    module SafeBlock
      def handle_errors(name)
        begin
          yield
          @runtime_error_occured = false
        rescue Exception => e
          log.fatal "#{name} died due to exception"
          log.error e unless e.kind_of?(SystemExit)
          Thread.list.each(&:kill) 
          exit(1)
        end
      end
    end
  end
end
