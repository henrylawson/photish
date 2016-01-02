module Photish
  module Config
    class Settings
      def initialize(runtime_config)
        @runtime_config = extract_config(runtime_config)
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
          .deep_symbolize_keys
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
          config_file_location: file_config_instance.path
        }
      end

      def file_config
        file_config_instance.hash
                            .deep_symbolize_keys
      end

      def default_config
        DefaultConfig.new
                     .hash
                     .deep_symbolize_keys
      end

      def file_config_instance
        @file_config_instance ||= FileConfig.new(runtime_config[:config_dir])
      end
    end
  end
end
