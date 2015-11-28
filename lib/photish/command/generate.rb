require 'photish/log/logger'
require 'photish/config/app_settings'
require 'photish/gallery/collection'
require 'photish/render/site'

module Photish
  module Command
    class Generate
      def initialize(runtime_config)
        @runtime_config = runtime_config
        @log = Logging.logger[self]
      end

      def execute
        Photish::Log::Logger.instance.setup_logging(config)

        log_important_config_values
        load_all_plugins
        log_album_and_photo_names
        render_whole_site
        log.info 'Site generation completed successfully'
      end

      private

      attr_reader :runtime_config,
                  :log

      def load_all_plugins
        Dir[File.join(site_dir, '_plugins', '*.rb')].each do |file|
          load file
        end

        Photish::Plugin::Repository.all_plugins.each do |plugin|
          log.info "Found plugin #{plugin}"
        end
      end

      def config
        @config ||= Photish::Config::AppSettings.new(runtime_config)
                                                .config
      end

      def log_important_config_values
        log.info "Photo directory: #{photo_dir}"
        log.info "Site directory: #{site_dir}"
        log.info "Output directory: #{output_dir}"
      end

      def log_album_and_photo_names
        collection.albums.each do |album|
          log.info album.name
          log.info album.photos.map(&:name)
        end
      end

      def render_whole_site
        Photish::Render::Site.new(templates,
                                  site_dir,
                                  output_dir)
                             .all_for(collection)
      end

      def photo_dir
        config.val(:photo_dir)
      end

      def output_dir
        config.val(:output_dir)
      end

      def site_dir
        config.val(:site_dir)
      end

      def collection
        @collection ||= Gallery::Collection.new(photo_dir, qualities)
      end

      def qualities
        config.val(:qualities)
              .map { |quality| OpenStruct.new(quality) }
      end

      def templates
        OpenStruct.new(config.val(:templates))
      end
    end
  end
end
