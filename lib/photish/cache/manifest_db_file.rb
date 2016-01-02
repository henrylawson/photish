module Photish
  module Cache
    class ManifestDbFile
      def initialize(output_dir, workers)
        @output_dir = output_dir
        @workers = workers
      end

      def concat_worker_db_files
        changes = (1..workers).inject({}) do |accumulator, worker_index|
          file = worker_db_file(worker_index)
          accumulator.merge!(YAML.load_file(file)) if File.exist?(file)
          accumulator
        end
        File.open(master_db_file, 'w') { |f| f.write(changes.to_yaml) }
      end

      def clear
        FileUtils.rm_rf(master_db_file)
      end

      def master_db_file
        FileUtils.mkdir_p(output_dir)
        File.join(output_dir, '.changes.yml')
      end

      def worker_db_file(index)
        FileUtils.mkdir_p(output_dir)
        File.join(output_dir, ".changes.#{index}.yml")
      end

      private

      attr_reader :output_dir,
                  :workers
    end
  end
end
