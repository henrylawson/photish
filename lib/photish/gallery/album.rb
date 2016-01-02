module Photish
  module Gallery
    class Album
      include Traits::Urlable
      include Traits::Albumable
      include Photish::Plugin::Pluginable

      delegate :qualities,
               :image_extensions,
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
                       .reject { |file| !File.file?(file) ||
                                          !image_format?(file) }
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
        image_extensions.include?(extension)
      end

      def album_class
        self.class
      end

      def url_end
        'index.html'
      end
    end
  end
end
