require 'photish/log/logger'
require 'photish/log/access_log'
require 'webrick'

module Photish
  module Command
    class Host
      def initialize(runtime_config)
        @config = Photish::Config::AppSettings.new(runtime_config)
                                              .config
        @log = Logging.logger[self]
      end

      def execute
        Photish::Log::Logger.instance.setup_logging(config)

        trap 'INT' do server.shutdown end
        log.info "Site will be running at http://0.0.0.0:#{port}/"
        server.start
        log.info "Site has been shutdown"
      end

      private

      attr_reader :config,
                  :log

      def server
        @server ||= WEBrick::HTTPServer.new(Port: port,
                                            DocumentRoot: output_dir,
                                            AccessLog: access_log,
                                            Logger: log)
      end

      def access_log
        [
          [Photish::Log::AccessLog.new,
           WEBrick::AccessLog::COMBINED_LOG_FORMAT]
        ]
      end

      def port
        config.val(:port)
      end

      def output_dir
        config.val(:output_dir)
      end
    end
  end
end
