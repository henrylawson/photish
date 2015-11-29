module Photish
  module Gallery
    class Collection
      include Photish::Gallery::Traits::Urlable
      include Photish::Gallery::Traits::Albumable
      include Photish::Gallery::Traits::Metadatable
      include Photish::Gallery::Traits::Breadcrumbable
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
