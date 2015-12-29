module Photish
  module Command
    class Init < Base
      def run
        if runtime_config.example
           init_example
        else
           init_barebones
        end
        log.debug "Photish site initiated successfully"
      end

      private

      def init_barebones
        FileUtils.cp_r(config_file, Dir.pwd)
        FileUtils.cp_r(gemfile_file, Dir.pwd)
        FileUtils.cp_r(gitignore_file, File.join(Dir.pwd, '.gitignore'))
        FileUtils.mkdir_p('photos')
        FileUtils.cp_r(barebones_site_dir, Dir.pwd)
      end

      def init_example
        FileUtils.cp_r(config_file, Dir.pwd)
        FileUtils.cp_r(gemfile_file, Dir.pwd)
        FileUtils.cp_r(gitignore_file, File.join(Dir.pwd, '.gitignore'))
        FileUtils.cp_r(example_photo_dir, Dir.pwd)
        FileUtils.cp_r(example_site_dir, Dir.pwd)
      end

      def gemfile_file
        asset_path('Gemfile')
      end

      def config_file
        asset_path('config.yml')
      end

      def gitignore_file
        asset_path('gitignore')
      end

      def example_photo_dir
        asset_path('example', 'photos')
      end

      def barebones_site_dir
        asset_path('barebones', 'site')
      end

      def example_site_dir
        asset_path('example', 'site')
      end

      def asset_path(*path)
        File.join(File.dirname(__FILE__), '..', 'assets', path)
      end
    end
  end
end
