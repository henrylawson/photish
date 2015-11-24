require 'photish/log/logger'
require 'webrick'

module Photish
  module Command
    class Host
      include ::Photish::Log::Logger

      def initialize(runtime_config)
        @config = Photish::Config::AppSettings.new(runtime_config)
                                              .config
      end

      def execute
        trap 'INT' do server.shutdown end
        server.start
        log "Site is running at 0.0.0.0:#{port}"
      end

      private

      attr_reader :config

      def server
        @server ||= WEBrick::HTTPServer.new(Port: port, 
                                            DocumentRoot: output_dir)
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
