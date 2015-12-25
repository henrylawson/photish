module Photish
  module Command
    class Base
      include Log::Loggable
      include Log::SafeBlock

      def initialize(runtime_config)
        @runtime_config = runtime_config
      end

      def execute
        setup_logging
        handle_errors(self.class.name) do
          run
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
