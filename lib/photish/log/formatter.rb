module Photish
  module Log
    class Formatter
      def initialize(color)
        @color = color
      end

      def call(severity, datetime, progname, msg)
        LogLine.new(@color, severity, datetime, progname, msg).format
      end

      private

      class LogLine
        def initialize(color, severity, datetime, progname, msg)
          @color = color
          @severity = severity
          @datetime = datetime
          @progname = progname
          @msg = msg
        end

        def format
          line = ''
          line << timestamp
          line << pid
          line << severity
          line << progname
          line << msg
          line
        end

        private

        SEV = {
          'DEBUG' => [:green,  :default],
          'INFO'  => [:green,  :default],
          'WARN'  => [:yellow, :default],
          'ERROR' => [:red,    :default],
          'FATAL' => [:white,  :red    ],
        }

       def color?
         !!@color
       end

        def severity
          str = "#{@severity}"
          str = str.colorize(color: SEV[@severity].first,
                             background: SEV[@severity].last) if color?
          " #{str} "
        end

        def timestamp
          str = "[#{@datetime.strftime("%Y-%m-%dT%H:%M:%S.%L")}]"
          str = str.colorize(:cyan) if color?
          str
        end

        def pid
          str = "[#{Process.pid.to_s.rjust(5, '0')}]"
          str = str.colorize(:light_magenta) if color?
          str
        end

        def progname
          str = "#{@progname}"
          str = str.colorize(:magenta) if color?
          str
        end

        def msg
          str = ': '
          if @msg.kind_of?(Exception)
            str << "#{@msg.class} \"#{@msg.message}\"\n"
            str << "#{@msg.backtrace.join("\n")}"
          else
            str << "#{@msg}"
          end
          str << "\n"
          str = str.colorize(:light_blue) if color?
          str
        end
      end
    end
  end
end
