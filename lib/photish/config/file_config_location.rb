module Photish
  module Config
    class FileConfigLocation
      FILE_NAME = 'config.yml'

      def initialize(site_dir)
        @site_dir = site_dir
      end

      def path
        File.join(directory, config_file_name)
      end

      private

      attr_reader :site_dir

      def directory
        site_dir || Dir.pwd
      end

      def config_file_name
        FILE_NAME
      end
    end
  end
end
