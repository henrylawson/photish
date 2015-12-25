module Photish
  module Log
    class Formatter
      def call(severity, datetime, progname, msg)
        LogLine.new(severity, datetime, progname, msg).format
      end

      private

      class LogLine
        def initialize(severity, datetime, progname, msg)
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
          line << reset_colors
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

        def severity
          str = "#{@severity}".colorize(color: SEV[@severity].first,
                                        background: SEV[@severity].last)
          " #{str} "
        end

        def timestamp
          "[#{@datetime.strftime("%Y-%m-%dT%H:%M:%S.%L")}]".colorize(:cyan)
        end

        def pid
          "[#{Process.pid.to_s.rjust(5, '0')}]".colorize(:light_magenta)
        end

        def progname
          "#{@progname}".colorize(:magenta)
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
          str.colorize(:light_blue)
        end

        def reset_colors
          ''.colorize(:default)
        end
      end
    end
  end
end
