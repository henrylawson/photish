module Photish
  module Config
    class AppSettings
      def initialize(runtime_config)
        @runtime_config = runtime_config
      end

      def config
        @config ||= Config::Settings
          .new(default_config)
          .override(file_config)
          .override(runtime_config)
      end

      private

      attr_reader :runtime_config

      def file_config
        config_location = Config::Location.new(runtime_config[:site_dir])
        Config::FileConfig.new(config_location.path).hash
      end

      def default_config
        Config::DefaultConfig.new.hash
      end
    end
  end
end
