module Photish
  module Gallery
    class Collection
      attr_reader :name,
                  :photos

      def initialize(name, photos)
        @name = name
        @photos = photos
      end
    end
  end
end
