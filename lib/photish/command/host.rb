module Photish
  module Command
    class Host < Base
      def run
        Photish::Log::Logger.instance.setup_logging(config)

        log.info "Site will be running at http://0.0.0.0:#{port}/"
        log.info "Monitoring paths #{paths_to_monitor}"

        regenerate_entire_site
        start_http_server_with_listener
      end

      private

      delegate :port,
               :output_dir,
               :site_dir,
               :photo_dir,
               :config_file_location,
               to: :config

      def start_http_server_with_listener
        trap 'INT' do server.shutdown end
        listener.start
        server.start
        listener.stop
        log.info "Photish host has shutdown"
      end

      def server
        @server ||= WEBrick::HTTPServer.new(Port: port,
                                            DocumentRoot: output_dir,
                                            AccessLog: access_log,
                                            Logger: log)
      end

      def listener
        @listener ||= Listen.to(*paths_to_monitor) do |modified, added, removed|
          log.info "File was modified #{modified}" if modified.present?
          log.info "File was added #{added}" if added.present?
          log.info "File was removed #{removed}" if removed.present?

          regenerate_entire_site
        end
      end

      def paths_to_monitor
        [site_dir,
         photo_dir]
      end

      def access_log
        [
          [Photish::Log::AccessLog.new,
           WEBrick::AccessLog::COMBINED_LOG_FORMAT]
        ]
      end

      def regenerate_entire_site
        log.info "Regenerating site"
        Photish::Command::Generate.new(runtime_config)
                                  .execute
      end
    end
  end
end
