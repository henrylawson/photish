require 'photish/gallery/album'
require 'photish/gallery/traits/albumable'
require 'photish/gallery/traits/metadatable'
require 'photish/gallery/traits/breadcrumbable'

module Photish
  module Gallery
    class Collection

      include ::Photish::Gallery::Traits::Urlable
      include ::Photish::Gallery::Traits::Albumable
      include ::Photish::Gallery::Traits::Metadatable
      include ::Photish::Gallery::Traits::Breadcrumbable

      attr_reader :qualities

      def initialize(path, qualities)
        @path = path
        @qualities = qualities
      end

      def name
        'Home'
      end

      def base_url_parts
        []
      end

      private

      attr_reader :path

      def album_class
        Album
      end

      def url_end
        'index.html'
      end

      def parent
        nil
      end
    end
  end
end
