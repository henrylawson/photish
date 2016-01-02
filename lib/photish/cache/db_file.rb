module Photish
  module Cache
    class DbFile
      def self.new_master(output_dir)
        new(path(output_dir, '.changes.yml'))
      end

      def self.new_worker(output_dir, index)
        new(path(output_dir, ".changes.#{index}.yml"))
      end

      def write(hash)
        File.open(file, 'w') do
          |f| f.write(hash.to_yaml)
        end
      end

      def read
        File.exist?(file) ? YAML.load_file(file) : {}
      end

      def clear
        FileUtils.rm_rf(file)
      end

      private

      attr_reader :file

      def initialize(file)
        @file = file
      end

      def self.path(output_dir, filename)
        FileUtils.mkdir_p(output_dir)
        path = File.join(output_dir, filename)
      end
    end
  end
end
