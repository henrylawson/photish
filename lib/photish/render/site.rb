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
        collection_template.render(collection)
        album_template.render(collection.all_albums)
        photo_template.render(collection.all_photos)
        image_conversion.render(collection.all_images)
      end

      private

      attr_reader :collection,
                  :site_dir,
                  :output_dir

      def image_conversion
        Photish::Render::ImageConversion.new(output_dir)
      end

      def album_template
        Photish::Render::Page.new(template_album_file, output_dir)
      end

      def photo_template
        Photish::Render::Page.new(template_photo_file, output_dir)
      end

      def collection_template
        Photish::Render::Page.new(template_collection_file, output_dir)
      end

      def template_collection_file
        File.join(site_dir, 'collection.slim')
      end

      def template_album_file
        File.join(site_dir, 'album.slim')
      end

      def template_photo_file
        File.join(site_dir, 'photo.slim')
      end
    end
  end
end
