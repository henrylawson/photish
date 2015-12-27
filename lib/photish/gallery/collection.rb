module Photish
  module Gallery
    class Collection
      include Traits::Urlable
      include Traits::Albumable
      include Traits::Metadatable
      include Photish::Plugin::Pluginable

      attr_reader :qualities,
                  :url_info

      def initialize(path, qualities, url_info)
        super
        @path = path
        @qualities = qualities
        @url_info = url_info
      end

      def name
        'Home'
      end

      def base_url_parts
        [url_info.base].flatten.compact
      end

      def plugin_type
        Photish::Plugin::Type::Collection
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
