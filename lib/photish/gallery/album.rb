module Photish
  module Gallery
    class Album
      include Traits::Urlable
      include Traits::Albumable
      include Traits::Metadatable
      include Traits::Breadcrumbable
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
        @name ||= File.basename(path)
      end

      def photos
        @photos ||= Dir.entries(path)
                       .reject { |file| ['.', '..'].include?(file) }
                       .map    { |file| File.join(path, file) }
                       .reject { |file| !File.file?(file) }
                       .reject { |file| !image_format?(file) }
                       .map    { |file| Photo.new(self, file) }
      end

      def plugin_type
        Photish::Plugin::Type::Album
      end

      private

      attr_reader :path,
                  :parent

      alias_method :base_url_name, :name

      def image_format?(file)
        extension = File.extname(file).split('.').last.try(:downcase)
        return if extension.nil?
        MIME::Types.type_for(extension).any? do
          |mime| mime.to_s.match(formats)
        end
      end

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
