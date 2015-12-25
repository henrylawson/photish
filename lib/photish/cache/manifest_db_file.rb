module Photish
  module Cache
    class ManifestDbFile
      def initialize(output_dir)
        @output_dir = output_dir
      end

      def concat_db_files(workers)
        changes = (1..workers).inject({}) do |accumulator, worker_index|
          file = worker_db_file(worker_index)
          accumulator.merge!(YAML.load_file(file)) if File.exist?(file)
          accumulator
        end
        File.open(db_file, 'w') { |f| f.write(changes.to_yaml) }
      end

      def clear
        FileUtils.rm_rf(db_file)
      end

      def db_file
        FileUtils.mkdir_p(output_dir)
        File.join(output_dir, '.changes.yml')
      end

      def worker_db_file(index)
        FileUtils.mkdir_p(output_dir)
        File.join(output_dir, ".changes.#{index}.yml")
      end

      private

      attr_reader :output_dir
    end
  end
end
