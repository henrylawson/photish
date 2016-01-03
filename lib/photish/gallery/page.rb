module Photish
  module Gallery
    class Page
      include Traits::Urlable
      include Traits::Albumable
      include Traits::Fileable
      include Plugin::Pluginable

      attr_reader :path

      delegate :url_info,
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

      def plugin_type
        Plugin::Type::Page
      end

      private

      attr_reader :parent,

      def base_url_name
        nil
      end

      def url_end
        basename_without_extension
      end
    end
  end
end
