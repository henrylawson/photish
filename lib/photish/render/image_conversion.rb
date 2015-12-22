module Photish
  module Render
    class ImageConversion
      def initialize(output_dir, worker_index, version_hash)
        @output_dir = output_dir
        @worker_index = worker_index
        @version_hash = version_hash
        @log = Logging.logger[self]
      end

      def render(images)
        preload
        images.each do |image|
          convert(image) if changed?(image.url_path, image.path)
        end
        flush_to_disk
      end

      private

      attr_reader :output_dir,
                  :log,
                  :worker_index,
                  :version_hash

      delegate :record,
               :changed?,
               :flush_to_disk,
               :preload,
               to: :change_manifest

      def convert(image)
        create_parent_directories(image)
        convert_with_imagemagick(image)
        record(image.url_path, image.path)
      end

      def convert_with_imagemagick(image)
        MiniMagick::Tool::Convert.new do |convert|
          convert << image.path
          convert.merge!(image.quality_params)
          convert << output_path(image)
          log.info "Performing image conversion #{convert.command}"
        end
      end

      def output_path(image)
        File.join(output_dir, image.url_parts)
      end

      def create_parent_directories(image)
        FileUtils.mkdir_p(File.join(output_dir, image.base_url_parts))
      end

      def change_manifest
        @change_manifest ||= ChangeManifest.new(output_dir,
                                                worker_index,
                                                version_hash)
      end
    end
  end
end
