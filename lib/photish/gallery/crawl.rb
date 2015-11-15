require 'pry'

module Photish
  module Gallery
    class Crawl
      def initialize(base_dir)
        @base_dir = base_dir
      end

      def load
        @collections ||= Dir.entries(base_dir)
                            .reject { |file| ['.', '..'].include?(file) }
                            .map { |file| File.join(base_dir, file) }
                            .map { |file| Collection.new(file) }
      end

      private

      attr_reader :base_dir
    end
  end
end
