require 'photish/gallery/traits/urlable'

module Photish
  module Gallery
    class Photo

      include Urlable

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
    end
  end
end
