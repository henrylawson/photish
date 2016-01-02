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
        db[key] = checksum
      end

      def changed?(key, file_path = nil)
        checksum = checksum_of_file(file_path || key)
        worker_db[key] = checksum
        checksum != db[key]
      end

      def flush_to_disk
        File.open(worker_db_file(worker_index), 'w') do
          |f| f.write(worker_db.to_yaml)
        end
      end

      def load_from_disk
        db
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
               to: :manifest_db_file

      def checksum_of_file(file_path)
        cache.fetch(file_path.hash) do |key|
          cache[key] = version_hash.to_s +
                       Digest::MD5.file(file_path).hexdigest
        end
      end

      def db
        return @db if @db
        @db = File.exist?(master_db_file) ? YAML.load_file(master_db_file) : {}
      end

      def manifest_db_file
        ManifestDbFile.new(output_dir, workers)
      end
    end
  end
end
