module Photish
  module Command
    class Generate < Base
      def run
        if worker_index == 0
          threads = (1..workers).map do |worker_index|
            Thread.new do
              system(photish_executable,
                     'generate',
                     "--worker_index=#{worker_index}") || exit(false)
            end
          end
          ThreadsWait.all_waits(*threads)
          concat_db_files
        else
          log.info "Worker ##{worker_index} starting"
          load_all_plugins
          render_whole_site
          log.info "Site generation completed, by Worker ##{worker_index}"
        end
      end

      private

      delegate :site_dir,
               :photo_dir,
               :output_dir,
               :qualities,
               :url,
               :workers,
               :worker_index,
               :photish_executable,
               to: :config

      def load_all_plugins
        Photish::Plugin::Repository.reload(log, site_dir)
      end

      def render_whole_site
        Photish::Render::Site.new(config)
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
