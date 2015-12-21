module Photish
  module Render
    class ChangeManifest
      def initialize(version_hash, output_dir)
        @version_hash = version_hash
        @output_dir = output_dir
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

      private

      attr_reader :output_dir,
                  :dirty,
                  :cache,
                  :version_hash

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
        @db = File.exist?(db_file) ? YAML.load_file(db_file) : {}
      end

      def db_file
        File.join(output_dir, '.changes.yml')
      end
    end
  end
end
