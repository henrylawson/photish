module Photish
  module Gallery
    class Collection
      include Traits::Urlable
      include Traits::Albumable
      include Traits::Metadatable
      include Traits::Breadcrumbable
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

      def all_url_paths
        @all_url_paths ||= [url_path,
                            all_albums.map(&:url_path),
                            all_photos.map(&:url_path),
                            all_images.map(&:url_path)].flatten
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
