module Photish
  module Command
    class Host < Base
      def run
        log.info "Site will be running at http://0.0.0.0:#{port}/"
        log.info "Monitoring paths #{paths_to_monitor}"

        regenerate_entire_site
        regenerate_thread
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
        log.info "Photish host has shutdown"
      ensure
        regenerate_thread.exit if @regenerate_thread
        listener.stop if @listener
      end

      def regenerate_thread
        @regenerate_thread ||= Thread.new do
          handle_errors('Regenerate Thread') do
            regenerate_loop
          end
        end
      end

      def regenerate_loop
        loop do
          queue.pop
          queue.clear
          regenerate_entire_site
        end
      end

      def server
        @server ||= WEBrick::HTTPServer.new(Port: port,
                                            DocumentRoot: output_dir,
                                            AccessLog: access_log,
                                            Logger: log)
      end

      def listener
        @listener ||= Listen.to(*paths_to_monitor) do |mod, add, del|
          handle_errors('File Change Listener') do
            handle_change(mod, add, del)
          end
        end
      end

      def handle_change(mod, add, del)
        changes = changes_as_hash(mod, add, del)
        log.info "File change detected: #{changes}}"
        queue.push(changes)
      end

      def changes_as_hash(mod, add, del)
        { modified: mod,
          added:    add,
          removed:  del, }
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

      def queue
        @queue ||= Queue.new
      end
    end
  end
end
