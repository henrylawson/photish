module Photish
  module Render
    class SiteWorker
      def initialize(config, version_hash)
        @config = config
        @version_hash = version_hash
      end

      def all_for(collection)
        [->{ album_template.render(subset(collection.all_albums))   },
         ->{ photo_template.render(subset(collection.all_photos))   },
         ->{ image_conversion.render(subset(collection.all_images)) }].shuffle
                                                                      .each(&:call)
      end

      private

      attr_reader :config,
                  :version_hash

      delegate :templates,
               :site_dir,
               :output_dir,
               :workers,
               :threads,
               :worker_index,
               to: :config

      def subset(items)
        (worker..(items.count-worker)).step(workers)
                                      .map { |x| items[x] }
                                      .compact
      end

      def worker
        worker_index - 1
      end

      def delete_unknown_files(expected_url_paths)
        path_set = Set.new(expected_url_paths)
        files_to_delete = Dir["#{output_dir}/**/*"].select do |f|
          relative_file_path = f.gsub(/#{output_dir}\/?/, '')
          File.file?(f) && !path_set.include?(relative_file_path)
        end
        FileUtils.rm_rf(files_to_delete)
      end

      def image_conversion
        ImageConversion.new(output_dir,
                            worker_index,
                            version_hash,
                            threads)
      end

      def album_template
        Page.new(layout_file,
                 template_album_file,
                 output_dir)
      end

      def photo_template
        Page.new(layout_file,
                 template_photo_file,
                 output_dir)
      end

      def layout_file
        File.join(site_dir, templates_dir, templates.layout)
      end

      def template_album_file
        File.join(site_dir,  templates_dir, templates.album)
      end

      def template_photo_file
        File.join(site_dir, templates_dir, templates.photo)
      end

      def templates_dir
        '_templates'
      end
    end
  end
end
