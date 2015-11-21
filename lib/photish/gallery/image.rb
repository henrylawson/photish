require 'active_support'
require 'active_support/core_ext'

module Photish
  module Gallery
    class Image

      include ::Photish::Gallery::Traits::Urlable

      delegate :name, to: :quality, prefix: true, allow_nil: true

      def initialize(parent, path, quality)
        @parent = parent
        @path = path
        @quality = quality
      end

      def name
        @name ||= File.basename(path, '.*')
      end

      private

      attr_reader :path,
                  :parent,
                  :quality

      alias_method :base_url_name, :name

      def url_end
        "#{slugify(name)}-#{slugify(quality_name)}#{extension}"
      end

      def extension
        @extentsion ||= File.extname(path)
      end

      def base_url_name
        'images'
      end
    end
  end
end
