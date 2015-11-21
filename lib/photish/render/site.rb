require 'photish/render/page'
require 'photish/render/image'

module Photish
  module Render
    class Site
      def initialize(collection, site_dir, output_dir)
        @collection = collection
        @site_dir = site_dir
        @output_dir = output_dir
      end

      def all
        write_rendered_collection_page
        write_rendered_album_pages
        write_rendered_photo_pages
        write_converted_images
      end

      private

      attr_reader :collection,
                  :site_dir,
                  :output_dir

      def write_converted_images
        Photish::Render::Image.new(output_dir)
                              .render(collection.all_images)
      end

      def write_rendered_album_pages
        Photish::Render::Page.new(template_album_file, output_dir)
                             .render(collection.all_albums)
      end

      def write_rendered_photo_pages
        Photish::Render::Page.new(template_photo_file, output_dir)
                             .render(collection.all_photos)
      end

      def write_rendered_collection_page
        Photish::Render::Page.new(template_collection_file, output_dir)
                             .render(collection)
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
