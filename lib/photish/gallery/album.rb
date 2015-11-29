module Photish
  module Gallery
    class Album
      include Photish::Gallery::Traits::Urlable
      include Photish::Gallery::Traits::Albumable
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

      def plugin_type
        Photish::Plugin::Type::Album
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
