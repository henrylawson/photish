module Photish
  module Config
    class Location
      FILE_NAME = 'config.yml'

      def initialize(site_dir)
        @site_dir = site_dir
      end

      def path
        ensure_expected_path_exists
        expected_path
      end

      private

      attr_reader :site_dir

      def ensure_expected_path_exists
        return if File.exist?(expected_path)
        raise "Config file does not exist at #{expected_path}"
      end

      def expected_path
        File.join(directory, config_file_name)
      end

      def directory
        site_dir || Dir.pwd
      end

      def config_file_name
        FILE_NAME
      end
    end
  end
end
