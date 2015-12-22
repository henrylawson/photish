module Photish
  module Render
    class ChangeManifest
      def initialize(output_dir, worker_index, version_hash)
        @output_dir = output_dir
        @worker_index = worker_index
        @version_hash = version_hash
        @dirty = false
        @cache = {}
      end

      def record(key, file_path = nil)
        @dirty = true
        db[key] = checksum_of_file(file_path || key)
      end

      def changed?(key, file_path = nil)
        checksum_of_file(file_path || key) != old_checksum_of_file(key)
      end

      def flush_to_disk
        return unless dirty
        File.open(db_file, 'w') { |f| f.write((db || {}).to_yaml) }
      end

      def preload
        db
      end

      def self.concat_db_files(output_dir, workers)
        changes = (1..workers).inject({}) do |changes, worker_index|
          file = worker_db_file(output_dir, worker_index)
          changes.merge(YAML.load_file(file)) if File.exist?(file)
        end
        File.open(db_file(output_dir), 'w') { |f| f.write(changes.to_yaml) }
      end

      def self.db_file(output_dir)
        File.join(output_dir, '.changes.yml')
      end

      def self.worker_db_file(output_dir, index)
        File.join(output_dir, ".changes.#{index}.yml")
      end

      private

      attr_reader :output_dir,
                  :dirty,
                  :cache,
                  :version_hash,
                  :worker_index

      def checksum_of_file(file_path)
        cache.fetch(file_path.hash) do |key|
          cache[key] = version_hash.to_s +
                       Digest::MD5.file(file_path).hexdigest
        end
      end

      def old_checksum_of_file(file_path)
        db[file_path]
      end

      def db
        return @db if @db
        @db = File.exist?(db_file) ? YAML.load_file(db_file) || {} : {}
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
