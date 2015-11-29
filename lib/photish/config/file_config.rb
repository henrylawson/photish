module Photish
  module Config
    class FileConfig
      def initialize(config_file_path)
        @config_file_path = config_file_path
      end

      def hash
        return {} if !File.exist?(config_file_path)
        YAML.load_file(config_file_path)
      end

      private

      attr_reader :config_file_path
    end
  end
end

