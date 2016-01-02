module Photish
  module Gallery
    class Collection
      include Traits::Urlable
      include Traits::Albumable
      include Plugin::Pluginable

      attr_reader :qualities,
                  :url_info,
                  :image_extensions

      def initialize(path, qualities, url_info, image_extensions)
        super
        @path = path
        @qualities = qualities
        @url_info = url_info
        @image_extensions = Set.new(image_extensions)
      end

      def name
        'Home'
      end

      def base_url_parts
        [url_info.base].flatten.compact
      end

      def plugin_type
        Plugin::Type::Collection
      end

      def all_url_parts
        @all_url_parts ||= [[url_parts],
                            all_albums.map(&:url_parts),
                            all_photos.map(&:url_parts),
                            all_images.map(&:url_parts)].flatten(1)
      end

      private

      attr_reader :path

      def album_class
        Album
      end

      def url_end
        'index.html'
      end

      def parent
        nil
      end
    end
  end
end
