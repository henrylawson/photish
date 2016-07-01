module Photish
  module Render
    class Image
      include Log::Loggable

      def initialize(config, version_hash)
        @config = config
        @version_hash = version_hash
      end

      def render(images)
        log.debug "Rendering #{images.count} images across #{threads} threads"

        setup_minimagick
        cache_load_from_disk
        threads = spawn_thread_instances(to_queue(images))
        threads.map(&:join)
        cache_flush_to_disk
      end

      private

      attr_reader :config,
                  :version_hash

      delegate :output_dir,
               :worker_index,
               :threads,
               :soft_failure,
               :workers,
               to: :config

      delegate :record,
               :changed?,
               :flush_to_disk,
               :load_from_disk,
               to: :cache,
               prefix: true

      def spawn_thread_instances(image_queue)
        (0...threads).map do
          Thread.new do
            process_images(image_queue)
          end
        end
      end

      def process_images(image_queue)
        while !image_queue.empty?
          process_next_image(image_queue)
        end
      end

      def process_next_image(image_queue)
        image = image_queue.pop
        convert(image) if regenerate?(image)
      rescue Errno::ENOENT
        log.warn "Image not found #{image.path}"
        raise unless soft_failure
      end

      def regenerate?(image)
        cache_changed?(image.url_path, image.path) ||
          !File.exist?(output_path(image))
      end

      def to_queue(images)
        image_queue = Queue.new
        Array(images).shuffle.each { |image| image_queue << image }
        image_queue
      end

      def convert(image)
        create_parent_directories(image)
        convert_with_imagemagick(image)
        cache_record(image.url_path, image.path)
      end

      def convert_with_imagemagick(image)
        MiniMagick::Tool::Convert.new do |convert|
          convert << image.path
          convert.merge!(image.quality_params)
          convert << output_path(image)
        end
      rescue MiniMagick::Error => e
        log.warn "Error occured while converting"
        log.warn e
        raise unless soft_failure
      end

      def output_path(image)
        File.join(output_dir, image.url_parts)
      end

      def create_parent_directories(image)
        FileUtils.mkdir_p(File.join(output_dir, image.base_url_parts))
      end

      def cache
        @cache ||= Cache::Manifest.new(output_dir,
                                       workers,
                                       worker_index,
                                       version_hash)
      end

      def minimagick_config
        config.dependencies.minimagick
      end

      def debug?
        config.logging.level == 'debug'
      end

      def setup_minimagick
        MiniMagick.configure do |config|
          config.cli = minimagick_config.cli.to_sym
          config.cli_path = minimagick_config.cli_path if minimagick_config.cli_path
          config.timeout = minimagick_config.timeout
          config.validate_on_create = minimagick_config.validate_on_create
          config.validate_on_write = minimagick_config.validate_on_write
          config.whiny = minimagick_config.whiny
        end
        MiniMagick.logger.level = Logger::DEBUG if debug?
      end
    end
  end
end
