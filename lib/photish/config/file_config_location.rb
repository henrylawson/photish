module Photish
  module Config
    class FileConfigLocation
      FILE_NAME = 'config.yml'

      def initialize(config_dir)
        @config_dir = config_dir
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
