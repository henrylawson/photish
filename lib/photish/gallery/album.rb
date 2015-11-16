require 'photish/gallery/photo'
require 'photish/gallery/traits/urlable'
require 'photish/gallery/traits/sub_groupable'

module Photish
  module Gallery
    class Album

      include ::Photish::Gallery::Traits::Urlable

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
                       .reject { |file| !File.file?(file) }
                       .map    { |file| Photo.new(self, file) }
      end
      
      def albums
        sub_groups(Album)
      end

      private
      
      attr_reader :path,
                  :parent

      include ::Photish::Gallery::Traits::SubGroupable
    end
  end
end
