require 'pry'

module Photish
  module Gallery
    class Crawl
      def initialize(base_dir)
        @base_dir = base_dir
      end

      def load
        collections = []
        Dir.foreach(base_dir) do |item|
          next if ['.', '..'].include?(item)
          item_path = File.join(base_dir, item)
          if Dir.exist?(item_path)
            photos = []
            Dir.foreach(item_path) do |photo|
              next if ['.', '..'].include?(photo)
              photo_path = File.join(item_path, photo)
              photos << Photo.new(File.basename(photo_path, ".*")) if File.exist?(photo_path)
            end
            collections << Collection.new(item, photos)
          end
        end
        collections
      end

      private

      attr_reader :base_dir
    end
  end
end
