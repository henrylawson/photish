module Photish
  module Gallery
    class Collection
      include Traits::Urlable
      include Traits::Albumable
      include Traits::Fileable
      include Plugin::Pluginable

      delegate :page_extension,
               :photo_dir,
               to: :config

      alias_method :path, :photo_dir

      def initialize(config)
        super
        @config = config
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
                            all_images.map(&:url_parts),
                            all_pages.map(&:url_parts),
                           ].flatten(1)
      end

      def image_extensions
        @image_extensions ||= Set.new(config.image_extensions)
      end

      def qualities
        @qualities ||= config.qualities
                             .map { |quality| OpenStruct.new(quality) }
      end

      def url_info
        config.url
      end

      private

      attr_reader :config

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
