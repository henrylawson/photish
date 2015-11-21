require 'photish/gallery/album'
require 'photish/gallery/traits/albumable'

module Photish
  module Gallery
    class Collection

      include ::Photish::Gallery::Traits::Urlable
      include ::Photish::Gallery::Traits::Albumable

      attr_reader :qualities

      def initialize(path, qualities)
        @path = path
        @qualities = qualities
      end

      def base_url_parts
        []
      end

      def all_photos
        all_albums.map(&:photos)
                  .flatten
      end

      private

      attr_reader :path

      def album_class
        Album
      end

      def url_end
        'index.html'
      end
    end
  end
end
