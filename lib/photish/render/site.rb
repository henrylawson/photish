require 'photish/render/page'

module Photish
  module Render
    class Site
      def initialize(collection, site_dir, output_dir)
        @collection = collection
        @site_dir = site_dir
        @output_dir = output_dir
      end

      def all
        write_rendered_index_page
        write_rendered_album_pages
        write_rendered_photo_pages
      end

      private

      attr_reader :collection,
                  :site_dir,
                  :output_dir

      def write_rendered_album_pages
        Photish::Render::Page.new(template_album_file, output_dir)
                             .render(collection.all_albums)
      end

      def write_rendered_photo_pages
        Photish::Render::Page.new(template_photo_file, output_dir)
                             .render(collection.all_photos)
      end

      def write_rendered_index_page
        Photish::Render::Page.new(template_index_file, output_dir)
                             .render(collection)
      end

      def template_index_file
        File.join(site_dir, 'index.slim')
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
