module Photish
  module Log
    class LogSetup
      LEVEL = {
        debug: Logger::DEBUG,
        info:  Logger::INFO,
        warn:  Logger::WARN,
        error: Logger::ERROR,
        fatal: Logger::FATAL,
      }

      include Singleton

      attr_accessor :setup_complete

      def initialize
        @config = nil
      end

      def configure(incoming_config)
        return if config
        String.disable_colorization = !incoming_config.colorize
        @config = incoming_config
      end

      def new_logger(name)
        logger = setup_new_logger(name, null_file)
        logger.extend(stdout_broadcast(name)) if output_to_stdout?
        logger.extend(file_broadcast(name)) if output_to_file?
        logger
      end

      private

      attr_reader :config

      delegate :output,
               :level,
               to: :config

      def null_file
        File.open(File::NULL, 'w')
      end

      def setup_new_logger(name, stream)
        logger = ActiveSupport::Logger.new(stream)
        logger.progname = name
        logger.level = logging_level
        logger
      end

      def file_broadcast(name)
        file = File.join('log', 'photish.log')
        FileUtils.mkdir_p('log')
        logger = setup_new_logger(name, file)
        logger.formatter = Log::Formatter.new
        ActiveSupport::Logger.broadcast(logger)
      end

      def stdout_broadcast(name)
        logger = setup_new_logger(name, STDOUT)
        logger.formatter = Log::Formatter.new
        ActiveSupport::Logger.broadcast(logger)
      end

      def logging_level
        LEVEL.fetch(level.try(:to_sym))
      end

      def output_to_stdout?
        output.include?('stdout')
      end

      def output_to_file?
        output.include?('file')
      end
    end
  end
end
