module Photish
  module Log
    class Logger
      include Singleton

      attr_accessor :setup_complete

      def initialize
        @setup_complete = false
      end

      def setup_logging(config)
        return if setup_complete
        setup_color_scheme if colorize?(config)
        setup_stdout_output if output_to_stdout?(config)
        setup_file_output if output_to_file?(config)

        Logging.logger.root.level = logging_level(config)
        self.setup_complete = true
      end

      private

      def logging_level(config)
        config.logging.level.to_sym
      end

      def colorize?(config)
        config.logging.colorize
      end

      def output_to_stdout?(config)
        config.logging.output.include?('stdout')
      end

      def output_to_file?(config)
        config.logging.output.include?('file')
      end

      def setup_color_scheme
        Logging.color_scheme('bright',
          levels: {
            info: :green,
            warn:  :yellow,
            error: :red,
            fatal: [:white, :on_red]
          },
          date: :blue,
          logger: :cyan,
          message: :magenta
        )
      end

      def setup_stdout_output
        Logging.appenders.stdout(
          'stdout',
          layout: Logging.layouts.pattern(
            pattern: '[%d] %-5l %c: %m\n',
            color_scheme: 'bright'
          )
        )
        Logging.logger.root.add_appenders('stdout')
      end

      def setup_file_output
        FileUtils.mkdir_p('log')
        file_appender = Logging.appenders.file('log/photish.log')
        Logging.logger.root.add_appenders(file_appender)
      end
    end
  end
end
