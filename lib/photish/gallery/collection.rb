require 'photish/gallery/album'
require 'photish/gallery/traits/albumable'

module Photish
  module Gallery
    class Collection

      include ::Photish::Gallery::Traits::Albumable

      def initialize(path)
        @path = path
      end

      def url
        '/' + url_parts.join('/')
      end

      def url_parts
        base_url_parts + ['index.html']
      end

      def base_url_parts
        []
      end

      def all_photos
        all_albums.map(&:photos).flatten
      end

      private

      attr_reader :path

      def album_class
        Album
      end
    end
  end
end
