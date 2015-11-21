require 'photish/gallery/traits/urlable'

module Photish
  module Gallery
    class Photo

      include ::Photish::Gallery::Traits::Urlable

      def initialize(parent, path)
        @parent = parent
        @path = path
      end

      def name
        @name ||= File.basename(path, '.*')
      end

      private

      attr_reader :path,
                  :parent

      def url_end
        'index.html'
      end
    end
  end
end
