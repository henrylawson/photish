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

      def render_whole_site
        Render::Model.new(config, version_hash)
                     .all_for(collection)
      end

      def collection
        @collection ||= Gallery::Collection.new(config)
      end
    end
  end
end
