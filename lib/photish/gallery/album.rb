require 'photish/gallery/photo'
require 'photish/gallery/traits/urlable'
require 'photish/gallery/traits/albumable'
require 'photish/gallery/traits/metadatable'
require 'photish/gallery/traits/breadcrumbable'
require 'active_support'
require 'active_support/core_ext'
require 'filemagic'

module Photish
  module Gallery
    class Album
      include ::Photish::Gallery::Traits::Urlable
      include ::Photish::Gallery::Traits::Albumable
      include ::Photish::Gallery::Traits::Metadatable
      include ::Photish::Gallery::Traits::Breadcrumbable

      delegate :qualities, to: :parent, allow_nil: true

      def initialize(parent, path)
        @parent = parent
        @path = path
      end

      def name
        @name ||= File.basename(path)
      end

      def photos
        @photos ||= Dir.entries(path)
                       .reject { |file| ['.', '..'].include?(file) }
                       .map    { |file| File.join(path, file) }
                       .reject { |file| !File.file?(file) }
                       .reject { |file| !FileMagic.new(FileMagic::MAGIC_MIME).file(file).match(formats) }
                       .map    { |file| Photo.new(self, file) }
      end

      private

      attr_reader :path,
                  :parent

      alias_method :base_url_name, :name

      def album_class
        self.class
      end

      def url_end
        'index.html'
      end

      def formats
        Regexp.union([
          /image/i
        ])
      end
    end
  end
end
