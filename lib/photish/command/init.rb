module Photish
  module Command
    class Init < Base
      def run
        FileUtils.cp_r(config_file, Dir.pwd)
        FileUtils.cp_r(gemfile_file, Dir.pwd)
        FileUtils.cp_r(gitignore_file, File.join(Dir.pwd, '.gitignore'))
        FileUtils.cp_r(photo_dir, Dir.pwd)
        FileUtils.cp_r(site_dir, Dir.pwd)
        log.info "Photish site initiated successfully"
      end

      private

      def gemfile_file
        asset_path('Gemfile')
      end

      def config_file
        asset_path('config.yml')
      end

      def gitignore_file
        asset_path('gitignore')
      end

      def photo_dir
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
