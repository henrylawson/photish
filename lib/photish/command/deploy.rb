module Photish
  module Command
    class Deploy < Base
      def run
        load_all_plugins
        log.info "Requested engine: #{engine}"

        return no_engine_found unless engine

        log.info "Deploying with engine #{engine_class}"
        engine_class.new(config, log).deploy
      end

      private

      delegate :engine,
               :site_dir,
               to: :config


      def no_engine_found
        log.info "No engine found..."
      end

      def load_all_plugins
        Photish::Plugin::Repository.reload(log, site_dir)
      end

      def engine_class
        @engine ||= deploy_plugins.find do |p|
          p.engine_name == engine
        end
      end

      def deploy_plugins
        Photish::Plugin::Repository.plugins_for(deploy_plugin_type)
      end

      def deploy_plugin_type
        Photish::Plugin::Type::Deploy
      end
    end
  end
end
