require 'photish/log/logger'

module Photish
  module Command
    class Init
      include ::Photish::Log::Logger

      def initialize(runtime_config)
        @runtime_config = runtime_config
      end

      def execute
        FileUtils.cp_r(config_file, Dir.pwd)
        FileUtils.cp_r(gitignore_file, File.join(Dir.pwd, '.gitignore'))
        FileUtils.cp_r(photos_dir, Dir.pwd)
        FileUtils.cp_r(site_dir, Dir.pwd)
        log "Photish site initiated successfully"
      end

      private

      attr_reader :runtime_config

      def config_file
        asset_path('config.yml')
      end

      def gitignore_file
        asset_path('gitignore')
      end

      def photos_dir
        asset_path('photos')
      end

      def site_dir
        asset_path('site')
      end

      def asset_path(*path)
        File.join(File.dirname(__FILE__), '..', 'assets', path)
      end
    end
  end
end
