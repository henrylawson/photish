module Photish
  module Cache
    class Manifest
      def initialize(output_dir, workers, worker_index, version_hash)
        @output_dir = output_dir
        @workers = workers
        @worker_index = worker_index
        @version_hash = version_hash
        @cache = {}
        @worker_db = {}
      end

      def record(key, file_path = nil)
        checksum = checksum_of_file(file_path || key)
        worker_db[key] = checksum
        master_db[key] = checksum
      end

      def changed?(key, file_path = nil)
        checksum = checksum_of_file(file_path || key)
        worker_db[key] = checksum
        checksum != master_db[key]
      end

      def flush_to_disk
        worker_db_file(worker_index).write(worker_db)
      end

      def load_from_disk
        master_db
      end

      private

      attr_reader :output_dir,
                  :cache,
                  :version_hash,
                  :worker_index,
                  :worker_db,
                  :workers

      delegate :master_db_file,
               :worker_db_file,
               to: :repository

      def checksum_of_file(file_path)
        cache.fetch(file_path.hash) do |key|
          cache[key] = hash(file_path)
        end
      end

      def hash(file_path)
        version_hash.to_s + Digest::MD5.file(file_path).hexdigest
      end

      def master_db
        @master_db ||= master_db_file.read
      end

      def repository
        @repository ||= Repository.new(output_dir, workers)
      end
    end
  end
end
