module Photish
  module Config
    class AppSettings
      def initialize(runtime_config)
        @runtime_config = symbolize(runtime_config)
      end

      def config
        @config ||= RecursiveOpenStruct.new(prioritized_config)
      end

      def version_hash
        @version_hash ||= Digest::MD5.hexdigest(prioritized_config.to_json)
      end

      private

      attr_reader :runtime_config

      def prioritized_config
        {}.merge(default_config)
          .merge(file_config)
          .merge(runtime_config)
          .merge(derived_config)
      end

      def derived_config
        {
          config_file_location: config_file_location
        }
      end

      def file_config
        symbolize(FileConfig.new(config_file_location)
                                            .hash)
      end

      def default_config
        symbolize(DefaultConfig.new.hash)
      end

      def config_file_location
        FileConfigLocation.new(runtime_config[:config_dir])
                          .path
      end

      def symbolize(hash)
        (hash || {})
          .deep_symbolize_keys
      end
    end
  end
end
