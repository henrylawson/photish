module Photish
  module Command
    class Deploy < Base
      def run
        load_all_plugins
        log.info "Requested engine: #{requested_engine}"

        return no_engine_found unless engine

        log.info "Deploying with engine #{engine}"
        engine.new(config, log).deploy
      end

      private

      def no_engine_found
        log.info "No engine found..."
      end

      def load_all_plugins
        Photish::Plugin::Repository.reload(log, site_dir)
      end

      def engine
        @engine ||= deploy_plugins.find do |p|
          p.engine_name == requested_engine
        end
      end

      def deploy_plugins
        Photish::Plugin::Repository.plugins_for(deploy_plugin_type)
      end

      def deploy_plugin_type
        Photish::Plugin::Type::Deploy
      end

      def requested_engine
        config.val(:engine)
      end

      def site_dir
        config.val(:site_dir)
      end
    end
  end
end
