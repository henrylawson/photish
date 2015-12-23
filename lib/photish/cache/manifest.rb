module Photish
  module Cache
    class Manifest
      def initialize(output_dir, worker_index, version_hash)
        @output_dir = output_dir
        @worker_index = worker_index
        @version_hash = version_hash
        @dirty = false
        @cache = {}
        @worker_db = {}
      end

      def record(key, file_path = nil)
        @dirty = true
        worker_db[key] = checksum_of_file(file_path || key)
      end

      def changed?(key, file_path = nil)
        checksum_of_file(file_path || key) != db[key] &&
          checksum_of_file(file_path || key) != worker_db[key]
      end

      def flush_to_disk
        return unless dirty
        File.open(worker_db_file, 'w') { |f| f.write(worker_db.to_yaml) }
      end

      def preload
        db
      end

      def self.concat_db_files(output_dir, workers)
        changes = (1..workers).inject({}) do |accumulator, worker_index|
          file = worker_db_file(output_dir, worker_index)
          accumulator.merge!(YAML.load_file(file)) if File.exist?(file)
          accumulator
        end
        File.open(db_file(output_dir), 'w') { |f| f.write(changes.to_yaml) }
      end

      def self.db_file(output_dir)
        FileUtils.mkdir_p(output_dir)
        File.join(output_dir, '.changes.yml')
      end

      def self.worker_db_file(output_dir, index)
        FileUtils.mkdir_p(output_dir)
        File.join(output_dir, ".changes.#{index}.yml")
      end

      private

      attr_reader :output_dir,
                  :dirty,
                  :cache,
                  :version_hash,
                  :worker_index,
                  :worker_db

      def checksum_of_file(file_path)
        cache.fetch(file_path.hash) do |key|
          cache[key] = version_hash.to_s +
                       Digest::MD5.file(file_path).hexdigest
        end
      end

      def db
        return @db if @db
        @db = File.exist?(db_file) ? YAML.load_file(db_file) : {}
      end

      def db_file
        self.class.db_file(output_dir)
      end

      def worker_db_file
        self.class.worker_db_file(output_dir, worker_index)
      end
    end
  end
end
