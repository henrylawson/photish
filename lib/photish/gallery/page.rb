module Photish
  module Gallery
    class Page
      include Traits::Urlable
      include Traits::Albumable
      include Plugin::Pluginable

      def initialize(parent, path)
        super
        @parent = parent
        @path = path
      end

      def name
        @name ||= File.basename(path, '.*')
      end

      def plugin_type
        Plugin::Type::Page
      end

      private

      attr_reader :parent,
                  :path
    end
  end
end
