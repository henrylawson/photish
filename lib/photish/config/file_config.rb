require 'yaml'

module Photish
  module Config
    class FileConfig
      def initialize(config_file_path)
        @config_file_path = config_file_path
      end

      def hash
        @hash ||= YAML.load_file(config_file_path)
      end

      private

      attr_reader :config_file_path
    end
  end
end

