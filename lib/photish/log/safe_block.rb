module Photish
  module Log
    module SafeBlock
      def handle_errors(name)
        begin
          yield
        rescue ScriptError, SignalException, StandardError SystemExit => e
          log.fatal "#{name} died due to #{e.class.name}"
          log.fatal e unless e.kind_of?(SystemExit)
          Thread.list.each(&:kill)
          exit(1)
        end
      end
    end
  end
end
