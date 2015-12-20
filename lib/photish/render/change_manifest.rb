module Photish
  module Render
    class ChangeManifest
      def initialize(output_dir)
        @output_dir = output_dir
      end

      def record(key, file_path = nil)
        update do |db|
          db[key] = md5_of_file(file_path || key)
        end
      end

      def changed?(key, file_path = nil)
        md5_of_file(file_path || key) != old_md5_of_file(key)
      end

      def flush_to_disk
        File.open(db_file, 'w') { |f| f.write((@db || {}).to_yaml) }
      end

      private

      attr_reader :output_dir

      def md5_of_file(file_path)
        Digest::MD5.file(file_path).hexdigest
      end
      
      def old_md5_of_file(file_path)
        read_from_file[file_path]
      end

      def update
        db = read_from_file
        yield(db)
        write_to_file(db)
      end

      def read_from_file
        @db ||= File.exist?(db_file) ? YAML.load_file(db_file) : {}
      end

      def write_to_file(db)
        @db = db
      end

      def db_file
        File.join(output_dir, '.changes.yml')
      end
    end
  end
end
