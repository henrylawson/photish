module Photish
  module Command
    class Generate < Base
      def run
        log_important_config_values
        load_all_plugins
        log_album_and_photo_names
        render_whole_site
        log.info 'Site generation completed successfully'
      end

      private

      delegate :output_dir,
               :site_dir,
               :photo_dir,
               :qualities,
               :templates,
               :url,
               :max_workers,
               to: :config

      def load_all_plugins
        Photish::Plugin::Repository.reload(log, site_dir)
      end

      def log_important_config_values
        log.info "Photo directory: #{photo_dir}"
        log.info "Site directory: #{site_dir}"
        log.info "Output directory: #{output_dir}"
      end

      def log_album_and_photo_names
        collection.albums.each do |album|
          log.info "Found album, #{album.name} with photos: #{album.photos.map(&:name)}"
        end
      end

      def render_whole_site
        Photish::Render::Site.new(templates,
                                  site_dir,
                                  output_dir,
                                  max_workers)
                             .all_for(collection)
      end

      def collection
        @collection ||= Gallery::Collection.new(photo_dir,
                                                qualities_mapped,
                                                url)
      end

      def qualities_mapped
        qualities.map { |quality| OpenStruct.new(quality) }
      end
    end
  end
end
