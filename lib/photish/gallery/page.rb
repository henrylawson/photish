module Photish
  module Gallery
    class Page
      include Traits::Urlable
      include Traits::Albumable
      include Traits::Fileable
      include Plugin::Pluginable

      attr_reader :path

      delegate :url_info,
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

      def plugin_type
        Plugin::Type::Page
      end

      private

      attr_reader :parent

      alias_method :base_url_name, :name

      def url_end
        'index.html'
      end
    end
  end
end
