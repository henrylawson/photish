module Photish
  module Command
    class Generate < Base
      def run
        log.info "Starting generation with #{workers} workers"

        spawn_all_workers
        wait_for_workers_to_complete
        concat_db_files

        log.info "Generation completed successfully"
      end

      private

      delegate :output_dir,
               :photish_executable,
               :workers,
               to: :config

      def spawn_all_workers
        @spawned_processes ||= (1..workers).map do |index|
          Process.spawn(worker_command(index))
        end
      end

      def wait_for_workers_to_complete
        @spawned_processes.map do |pid|
          Process.waitpid(pid)
        end
      end

      def worker_command(worker_index)
        [photish_executable,
         'worker',
         "--worker_index=#{worker_index}"].join(' ')
      end

      def concat_db_files
        Render::ChangeManifest.concat_db_files(output_dir,
                                               workers)
      end
    end
  end
end
