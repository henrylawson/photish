require 'photish/gallery/photo'

module Photish
  module Gallery
    class Album
      def initialize(path)
        @path = path
      end

      def name
        @name ||= File.basename(path)
      end

      def photos
        @photos ||= Dir.entries(path)
                       .reject { |file| ['.', '..'].include?(file) }
                       .map    { |file| File.join(path, file) }
                       .map    { |file| Photo.new(file) }
      end

      private
      
      attr_reader :path
    end
  end
end
