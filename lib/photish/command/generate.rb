module Photish
  module Command
    class Generate < Base
      def run
        log.info "Starting generation with #{workers} workers"

        clear_cache if force_regeneration?
        spawn_all_workers
        load_all_plugins
        wait_for_workers_to_complete
        concat_db_files
        perform_serial_generation

        log.info "Generation completed successfully"
      end

      private

      delegate :output_dir,
               :photo_dir,
               :url,
               :site_dir,
               :qualities,
               :photish_executable,
               :workers,
               :force,
               to: :config

      def force_regeneration?
        force == true
      end

      def clear_cache
        Cache::ManifestDbFile.clear(output_dir)
      end

      def load_all_plugins
        Plugin::Repository.reload(log, site_dir)
      end

      def spawn_all_workers
        return single_worker if one_worker?
        @spawned_processes ||= (1..workers).map do |index|
          Process.spawn(ENV, worker_command(index))
        end
      end

      def wait_for_workers_to_complete
        return if one_worker?
        @spawned_processes.map do |pid|
          Process.waitpid(pid)
        end
      end

      def one_worker?
        workers == 1
      end

      def single_worker
        Worker.new(runtime_config.merge(worker_index: 1)).execute
      end

      def perform_serial_generation
        Render::Site.new(config)
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

      def worker_command(worker_index)
        [photish_executable,
         'worker',
         "--worker_index=#{worker_index}"].join(' ')
      end

      def concat_db_files
        Cache::ManifestDbFile.concat_db_files(output_dir, workers)
      end
    end
  end
end
