module Photish
  module Gallery
    class Photo
      include Photish::Gallery::Traits::Urlable
      include Photish::Gallery::Traits::Metadatable
      include Photish::Gallery::Traits::Breadcrumbable
      include Photish::Plugin::Pluginable

      delegate :qualities,
               :url_info,
               to: :parent, allow_nil: true

      def initialize(parent, path)
        super
        @parent = parent
        @path = path
      end

      def name
        @name ||= File.basename(path, '.*')
      end

      def images
        qualities.map { |quality| Photish::Gallery::Image.new(self, path, quality) }
      end

      def exif
        MiniExiftool.new(path)
      end

      def plugin_type
        Photish::Plugin::Type::Photo
      end

      private

      attr_reader :path,
                  :parent

      alias_method :base_url_name, :name

      def url_end
        'index.html'
      end
    end
  end
end
