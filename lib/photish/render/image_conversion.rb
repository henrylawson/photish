module Photish
  module Render
    class ImageConversion
      def initialize(output_dir, max_workers)
        @output_dir = output_dir
        @max_workers = max_workers
        @log = Logging.logger[self]
      end

      def render(images)
        image_queue = to_queue(images)

        log.info "Rendering #{images.count} across #{max_workers} threads"

        workers = (0...max_workers).map do
          Thread.new do
            begin
              while image = image_queue.pop(true)
                convert(image) if changed?(image.url_path, image.path)
              end
            rescue ThreadError => e
              log.info "Expected exception, queue is empty #{e.class} \"#{e.message}\" #{e.backtrace.join("\n")}"
            end
          end
        end
        workers.map(&:join)
        flush_to_disk
      end

      private

      attr_reader :output_dir,
                  :log,
                  :max_workers

      delegate :record,
               :changed?,
               :flush_to_disk,
               to: :change_manifest

      def to_queue(images)
        image_queue = Queue.new
        Array(images).each { |image| image_queue << image }
        image_queue
      end

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
        @change_manifest ||= ChangeManifest.new(output_dir)
      end
    end
  end
end
