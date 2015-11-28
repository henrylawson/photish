require 'active_support'
require 'active_support/core_ext'
require 'photish/plugins/plugin'

module Photish
  module Gallery
    class Image
      include Photish::Gallery::Traits::Urlable

      Photish::Plugin.constants.each do |plugin_klazz|
        include plugin_klazz if plugin_klazz.is_for?(PluginType::Image)
      end

      delegate :name,
               :params,
               to: :quality, prefix: true, allow_nil: true

      attr_reader :path

      def initialize(parent, path, quality)
        @parent = parent
        @path = path
        @quality = quality
      end

      def name
        @name ||= "#{basename} #{quality_name}"
      end

      private

      attr_reader :parent,
                  :quality

      alias_method :base_url_name, :name

      def url_end
        "#{slugify(basename)}-#{slugify(quality_name)}#{extension}"
      end

      def basename
        @basename ||= File.basename(path, '.*')
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
