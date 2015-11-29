module Photish
  module Command
    class Base
      def initialize(runtime_config)
        @runtime_config = runtime_config
        @log = Logging.logger[self]
      end

      def execute
        setup_logging
        begin
          run
        rescue => e
          log.fatal "An exception occured #{e.class} \"#{e.message}\" #{e.backtrace.join("\n")}"
          false
        end
      end

      protected

      attr_reader :runtime_config,
                  :log

      def config
        @config ||= Photish::Config::AppSettings.new(runtime_config)
                                                .config
      end

      private

      def setup_logging
        Photish::Log::Logger.instance.setup_logging(config)
      end
    end
  end
end
