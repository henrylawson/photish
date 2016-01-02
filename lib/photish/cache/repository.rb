module Photish
  module Cache
    class Repository
      def initialize(output_dir, workers)
        @output_dir = output_dir
        @workers = workers
        @worker_db_file_cache = {}
      end

      delegate :clear,
               to: :master_db_file,
               prefix: true

      def concat_worker_db_files
        master_db_file.write(accumulate_changes)
      end

      def master_db_file
        @master_db_file ||= DbFile.new_master(output_dir)
      end

      def worker_db_file(index)
        worker_db_file_cache.fetch(index) do
          DbFile.new_worker(output_dir, index)
        end
      end

      private

      attr_reader :output_dir,
                  :workers,
                  :worker_db_file_cache

      def accumulate_changes
        (1..workers).inject({}) do |accumulator, worker_index|
          db_file = worker_db_file(worker_index)
          accumulator.merge(db_file.read)
        end
      end
    end
  end
end
