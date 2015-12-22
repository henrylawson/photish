module Photish
  module Render
    class Site
      def initialize(config)
        @config = config
      end

      def all_for(collection)
        if worker_index == 1
          delete_unknown_files(collection.all_url_paths)
          move_non_ignored_site_contents
          collection_template.render(collection)
        end

        [->{ album_template.render(subset(collection.all_albums))   },
         ->{ photo_template.render(subset(collection.all_photos))   },
         ->{ image_conversion.render(subset(collection.all_images)) }].shuffle
                                                                      .each(&:call)
      end

      private

      attr_reader :config

      delegate :templates,
               :site_dir,
               :output_dir,
               :workers,
               :threads,
               :version_hash,
               :worker_index,
               to: :config

      def subset(items)
        items.in_groups(workers, false)[worker_index-1] || []
      end

      def delete_unknown_files(expected_url_paths)
        path_set = Set.new(expected_url_paths)
        files_to_delete = Dir["#{output_dir}/**/*"].select do |f|
          relative_file_path = f.gsub(/#{output_dir}\/?/, '')
          File.file?(f) && !path_set.include?(relative_file_path)
        end
        FileUtils.rm_rf(files_to_delete)
      end

      def move_non_ignored_site_contents
        FileUtils.mkdir_p(output_dir)
        FileUtils.cp_r(non_ignored_site_contents, output_dir)
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

      def collection_template
        Page.new(layout_file,
                 template_collection_file,
                 output_dir)
      end

      def non_ignored_site_contents
        Dir.glob(File.join(site_dir, '[!_]*'))
      end

      def layout_file
        File.join(site_dir, templates_dir, templates.layout)
      end

      def template_collection_file
        File.join(site_dir, templates_dir, templates.collection)
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
