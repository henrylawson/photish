module Photish
  module Render
    class ChangeManifest
      def initialize(output_dir)
        @output_dir = output_dir
        @dirty = false
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

      private

      attr_reader :output_dir,
                  :dirty

      def checksum_of_file(file_path)
        XXhash.xxh32_stream(File.open(file_path))
      end
      
      def old_checksum_of_file(file_path)
        db[file_path]
      end

      def db
        @db ||= File.exist?(db_file) ? YAML.load_file(db_file) : {}
      end

      def db_file
        File.join(output_dir, '.changes.yml')
      end
    end
  end
end
