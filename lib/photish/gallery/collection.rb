require 'photish/gallery/album'
require 'photish/gallery/traits/sub_groupable'

module Photish
  module Gallery
    class Collection
      def initialize(path)
        @path = path
      end

      def albums
        sub_groups(Album)
      end

      def url
        url_parts.join('/')
      end

      def url_parts
        base_url_parts + ['index.html']
      end

      def base_url_parts
        []
      end

      private

      attr_reader :path

      include ::Photish::Gallery::Traits::SubGroupable
    end
  end
end
