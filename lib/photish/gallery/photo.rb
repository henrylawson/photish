require 'photish/gallery/traits/urlable'
require 'photish/gallery/traits/metadatable'
require 'photish/gallery/traits/breadcrumbable'
require 'photish/gallery/image'
require 'active_support'
require 'active_support/core_ext'
require 'mini_exiftool'

module Photish
  module Gallery
    class Photo

      include ::Photish::Gallery::Traits::Urlable
      include ::Photish::Gallery::Traits::Metadatable
      include ::Photish::Gallery::Traits::Breadcrumbable

      delegate :qualities, to: :parent, allow_nil: true

      def initialize(parent, path)
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
