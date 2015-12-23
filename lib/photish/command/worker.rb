module Photish
  module Command
    class Worker < Base
      def run
        log.info "Worker ##{worker_index} starting"

        load_all_plugins
        render_whole_site

        log.info "Site generation completed, by Worker ##{worker_index}"
      end

      private

      delegate :site_dir,
               :photo_dir,
               :output_dir,
               :qualities,
               :url,
               :worker_index,
               to: :config

      def load_all_plugins
        Photish::Plugin::Repository.reload(log, site_dir)
      end

      def render_whole_site
        Photish::Render::Site.new(config, version_hash)
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

      def concat_db_files
        Render::ChangeManifest.concat_db_files(output_dir,
                                               workers)
      end
    end
  end
end
