require 'yaml'
require 'active_support'
require 'active_support/core_ext'
require 'photish/config/default_config'
require 'photish/config/file_config'

module Photish
  module Config
    class Settings
      def initialize(config = nil)
        @config = compact_symbolize(config)
      end

      def val(key)
        config[key.to_sym]
      end

      def override(hash)
        cleaned_hash = compact_symbolize(hash)
        self.class.new(config.merge(cleaned_hash))
      end

      private

      attr_reader :config

      def compact_symbolize(hash)
        (hash || {})
          .compact
          .deep_symbolize_keys
      end
    end
  end
end
