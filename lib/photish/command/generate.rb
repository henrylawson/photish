module Photish
  module Command
    class Generate < Base
      def run
        log.debug "Generating with #{workers} workers and #{threads} threads"

        clear if force_regeneration?
        spawn_all_workers
        load_all_plugins
        wait_for_workers_to_complete
        concat_db_files(workers)
        perform_serial_generation

        log.debug "Generation completed successfully"
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
               :threads,
               :image_extensions,
               to: :config

      delegate :concat_db_files,
               :clear,
               to: :manifest_db_file

      def force_regeneration?
        force == true
      end

      def load_all_plugins
        Plugin::Repository.instance.reload(config)
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
                                                url,
                                                image_extensions)
      end

      def qualities_mapped
        qualities.map { |quality| OpenStruct.new(quality) }
      end

      def worker_command(worker_index)
        [photish_executable,
         'worker',
         "--worker_index=#{worker_index}"].join(' ')
      end

      def manifest_db_file
        Cache::ManifestDbFile.new(output_dir)
      end
    end
  end
end
