module Photish
  module Command
    class Base
      def initialize(runtime_config)
        @runtime_config = runtime_config
        @log = Logging.logger[self]
      end

      def execute
        Photish::Log::Logger.instance.setup_logging(config)
        run
      rescue => e
        log.fatal "An exception occured #{e.class} \"#{e.message}\" #{e.backtrace.join("\n")}"
        false
      end

      protected

      attr_reader :runtime_config,
                  :log

      def config
        @config ||= Photish::Config::AppSettings.new(runtime_config)
                                                .config
      end
    end
  end
end
