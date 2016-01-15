module Photish
  module Gallery
    class Image
      include Traits::Urlable
      include Traits::Fileable
      include Plugin::Pluginable

      delegate :name,
               :params,
               to: :quality,
               prefix: true,
               allow_nil: true

      delegate :url_info,
               :config,
               to: :parent,
               allow_nil: true

      attr_reader :path

      def initialize(parent, path, quality)
        super
        @parent = parent
        @path = path
        @quality = quality
      end

      def name
        @name ||= "#{basename_without_extension} #{quality_name}"
      end

      def plugin_type
        Plugin::Type::Image
      end

      private

      attr_reader :parent,
                  :quality

      alias_method :base_url_name, :name

      def url_end
        @url_end ||= slugify("#{basename_without_extension}-#{quality_name}.#{extension}")
      end

      def base_url_name
        'images'
      end
    end
  end
end
