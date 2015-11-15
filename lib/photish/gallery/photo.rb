module Photish
  module Gallery
    class Photo
      def initialize(path)
        @path = path
      end

      def name
        @name ||= File.basename(path, '.*')
      end

      private

      attr_reader :path
    end
  end
end
