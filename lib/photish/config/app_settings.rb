module Photish
  module Config
    class AppSettings
      def initialize(runtime_config)
        @runtime_config = compact_symbolize(runtime_config)
      end

      def config
        @config ||= RecursiveOpenStruct.new(prioritized_config)
      end

      private

      attr_reader :runtime_config

      def prioritized_config
        {}.merge(default_config)
          .merge(file_config)
          .merge(runtime_config)
      end

      def file_config
        compact_symbolize(Config::FileConfig.new(file_config_location)
                                            .hash)
      end

      def default_config
        compact_symbolize(Config::DefaultConfig.new.hash)
      end

      def file_config_location
        Config::Location.new(runtime_config[:site_dir])
                        .path
      end

      def compact_symbolize(hash)
        (hash || {})
          .compact
          .deep_symbolize_keys
      end
    end
  end
end
