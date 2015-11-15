module Photish
  module Gallery
    class Photo
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end
  end
end
