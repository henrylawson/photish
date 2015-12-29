module Photish
  module Config
    class AppSettings
      def initialize(runtime_config)
        @runtime_config = symbolize(extract_config(runtime_config))
      end

      def config
        @config ||= RecursiveOpenStruct.new(prioritized_config)
      end

      def version_hash
        @version_hash ||= Digest::MD5.hexdigest(sensitive_config.to_json)
      end

      private

      attr_reader :runtime_config

      def extract_config(hash)
        {}.deep_merge(hash)
          .deep_merge(JSON.parse(hash.fetch('config_override', '{}')))
      end

      def prioritized_config
        @prioritized_config = {}.deep_merge(default_config)
                                .deep_merge(file_config)
                                .deep_merge(runtime_config)
                                .deep_merge(derived_config)
      end

      def sensitive_config
        prioritized_config.slice(:qualities)
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
