module Photish
  module Command
    class Worker < Base
      def run
        log.debug "Worker ##{worker_index} starting"

        load_all_plugins
        render_whole_site

        log.debug "Site generation completed, by Worker ##{worker_index}"
      end

      private

      delegate :site_dir,
               :photo_dir,
               :output_dir,
               :qualities,
               :url,
               :worker_index,
               :image_extensions,
               to: :config

      def load_all_plugins
        return if Plugin::Repository.instance.loaded?
        Plugin::Repository.instance.reload(config)
      end

      def render_whole_site
        Render::SiteWorker.new(config, version_hash)
                          .all_for(collection)
      end

      def collection
        @collection ||= Gallery::Collection.new(photo_dir,
                                                qualities_mapped,
                                                url,
                                                image_extensions)
      end

      def qualities_mapped
        qualities.map { |quality| OpenStruct.new(quality) }
      end
    end
  end
end
