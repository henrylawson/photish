module Photish
  module Render
    class ChangeManifest
      def initialize(output_dir)
        @output_dir = output_dir
      end

      def record(key, file_path = nil)
        db[key] = md5_of_file(file_path || key)
      end

      def changed?(key, file_path = nil)
        md5_of_file(file_path || key) != old_md5_of_file(key)
      end

      def flush_to_disk
        File.open(db_file, 'w') { |f| f.write((db || {}).to_yaml) }
      end

      private

      attr_reader :output_dir

      def md5_of_file(file_path)
        Digest::MD5.file(file_path).hexdigest
      end
      
      def old_md5_of_file(file_path)
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
