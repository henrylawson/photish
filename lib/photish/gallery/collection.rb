require 'photish/gallery/album'

module Photish
  module Gallery
    class Collection
      def initialize(base_dir)
        @base_dir = base_dir
      end

      def albums
        @albums ||= Dir.entries(base_dir)
                       .reject { |file| ['.', '..'].include?(file) }
                       .map    { |file| File.join(base_dir, file) }
                       .reject { |file| !Dir.exist?(file) }
                       .map    { |file| Album.new(self, file) }
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

      attr_reader :base_dir
    end
  end
end
