module Photish
  module Config
    class FileConfig
      FILE_NAME = 'config.yml'

      def initialize(config_dir)
        @config_dir = config_dir
      end

      def hash
        return {} if !File.exist?(path)
        YAML.load_file(path)
      end

      def path
        File.join(directory, config_file_name)
      end

      private

      attr_reader :config_dir

      def directory
        config_dir || Dir.pwd
      end

      def config_file_name
        FILE_NAME
      end
    end
  end
end

