require 'photish/gallery/photo'
require 'photish/gallery/traits/urlable'

module Photish
  module Gallery
    class Album

      include Urlable

      def initialize(parent, path)
        @parent = parent
        @path = path
      end

      def name
        @name ||= File.basename(path)
      end

      def photos
        @photos ||= Dir.entries(path)
                       .reject { |file| ['.', '..'].include?(file) }
                       .map    { |file| File.join(path, file) }
                       .map    { |file| Photo.new(self, file) }
      end

      private
      
      attr_reader :path,
                  :parent
    end
  end
end
