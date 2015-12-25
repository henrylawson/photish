module Photish
  module Command
    class Base
      include Log::Loggable

      def initialize(runtime_config)
        @runtime_config = runtime_config
      end

      def execute
        setup_logging
        begin
          run
        rescue => e
          log.fatal "An exception occured #{e.class} \"#{e.message}\" #{e.backtrace.join("\n")}"
          exit(false)
        end
      end

      protected

      attr_reader :runtime_config

      delegate :config,
               :version_hash,
               to: :app_settings

      private

      def app_settings
        @app_settings ||= Config::AppSettings.new(runtime_config)
      end

      def setup_logging
        Log::Logger.instance.setup_logging(config)
      end
    end
  end
end
