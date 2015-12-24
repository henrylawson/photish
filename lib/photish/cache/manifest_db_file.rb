module Photish
  module Cache
    module ManifestDbFile
      def concat_db_files(output_dir, workers)
        changes = (1..workers).inject({}) do |accumulator, worker_index|
          file = worker_db_file(output_dir, worker_index)
          accumulator.merge!(YAML.load_file(file)) if File.exist?(file)
          accumulator
        end
        File.open(db_file(output_dir), 'w') { |f| f.write(changes.to_yaml) }
      end

      def clear(output_dir)
        FileUtils.rm_rf(db_file(output_dir))
      end

      def db_file(output_dir)
        FileUtils.mkdir_p(output_dir)
        File.join(output_dir, '.changes.yml')
      end

      def worker_db_file(output_dir, index)
        FileUtils.mkdir_p(output_dir)
        File.join(output_dir, ".changes.#{index}.yml")
      end

      module_function :concat_db_files,
                      :db_file,
                      :worker_db_file,
                      :clear
    end
  end
end
