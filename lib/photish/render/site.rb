module Photish
  module Render
    class Site
      def initialize(templates, site_dir, output_dir, max_workers, version_hash)
        @templates = templates
        @site_dir = site_dir
        @output_dir = output_dir
        @max_workers = max_workers
        @version_hash = version_hash
      end

      def all_for(collection)
        delete_unknown_files(collection.all_url_paths)
        move_non_ignored_site_contents

        collection_template.render(collection)
        album_template.render(collection.all_albums)
        photo_template.render(collection.all_photos)

        image_conversion.render(collection.all_images)
      end

      private

      attr_reader :templates,
                  :site_dir,
                  :output_dir,
                  :max_workers,
                  :version_hash

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
                            max_workers,
                            version_hash)
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
