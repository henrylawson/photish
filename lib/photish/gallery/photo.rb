module Photish
  module Gallery
    class Photo
      include Traits::Urlable
      include Traits::Fileable
      include Plugin::Pluginable

      delegate :qualities,
               :url_info,
               :config,
               to: :parent,
               allow_nil: true

      def initialize(parent, path)
        super
        @parent = parent
        @path = path
      end

      def name
        @name ||= basename_without_extension
      end

      def images
        @images ||= qualities.map { |quality| Image.new(self, path, quality) }
      end

      def plugin_type
        Plugin::Type::Photo
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
