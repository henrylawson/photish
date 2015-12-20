module Photish
  module Render
    class ImageConversion
      def initialize(output_dir)
        @output_dir = output_dir
        @log = Logging.logger[self]
      end

      def render(images)
        image_queue = to_queue(images)

        log.info "Rendering #{images.count} across #{max_cpus} threads"

        workers = (0...max_cpus).map do
          Thread.new do
            begin
              while image = image_queue.pop(true)
                convert(image)
              end
            rescue ThreadError => e
              log.info "Expected exception, queue is empty #{e.class} \"#{e.message}\" #{e.backtrace.join("\n")}"
            end
          end
        end
        workers.map(&:join)
      end

      private

      attr_reader :output_dir,
                  :log

      def to_queue(images)
        image_queue = Queue.new
        Array(images).each { |image| image_queue << image }
        image_queue
      end

      def convert(image)
        create_parent_directories(image)
        convert_with_imagemagick(image)
      end

      def convert_with_imagemagick(image)
        MiniMagick::Tool::Convert.new do |convert|
          convert << image.path
          convert.merge!(image.quality_params)
          convert << File.join(output_dir, image.url_parts)
          log.info "Performing image conversion #{convert.command}"
        end
      end

      def create_parent_directories(image)
        FileUtils.mkdir_p(File.join(output_dir, image.base_url_parts))
      end

      def max_cpus
        Facter.value('processors')['count']
      end
    end
  end
end
