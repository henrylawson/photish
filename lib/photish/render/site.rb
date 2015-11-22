require 'photish/render/page'
require 'photish/render/image_conversion'

module Photish
  module Render
    class Site
      def initialize(collection, site_dir, output_dir)
        @collection = collection
        @site_dir = site_dir
        @output_dir = output_dir
      end

      def all
        move_non_ignored_site_contents
        collection_template.render(collection)
        album_template.render(collection.all_albums)
        photo_template.render(collection.all_photos)
        image_conversion.render(collection.all_images)
      end

      private

      attr_reader :collection,
                  :site_dir,
                  :output_dir

      def move_non_ignored_site_contents
        FileUtils.mkdir_p(output_dir)
        FileUtils.cp_r(non_ignored_site_contents, output_dir)
      end

      def image_conversion
        Photish::Render::ImageConversion.new(output_dir)
      end

      def album_template
        Photish::Render::Page.new(layout_file, template_album_file, output_dir)
      end

      def photo_template
        Photish::Render::Page.new(layout_file, template_photo_file, output_dir)
      end

      def collection_template
        Photish::Render::Page.new(layout_file, template_collection_file, output_dir)
      end

      def non_ignored_site_contents
        Dir.glob(File.join(site_dir, '[!_]*'))
      end

      def layout_file
        File.join(site_dir, '_templates', 'layout.slim')
      end

      def template_collection_file
        File.join(site_dir, '_templates', 'collection.slim')
      end

      def template_album_file
        File.join(site_dir,  '_templates', 'album.slim')
      end

      def template_photo_file
        File.join(site_dir, '_templates', 'photo.slim')
      end
    end
  end
end
