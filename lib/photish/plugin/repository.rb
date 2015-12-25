module Photish
  module Plugin
    class Repository
      include Singleton
      include Log::Loggable

      def reload(site_dir)
        log.info "Loading plugins..."

        load_each_plugin_file(site_dir)
        clear_plugin_cache
        load_each_plugin_constant
      end

      def plugins_for(type)
        all_plugins.reject { |m| !m.is_for?(type) }
      end

      def all_plugins
        @all_plugins ||= constants.map    { |m| constantize(m) }
                                  .reject { |m| ignored_modules.include?(m) }
      end

      def loaded?
        @all_plugins.present?
      end

      private

      def load_each_plugin_constant
        all_plugins.each do |plugin|
          log.info "Found plugin #{plugin}"
        end
      end

      def clear_plugin_cache
        @all_plugins = nil
      end

      def load_each_plugin_file(site_dir)
        Dir[File.join(site_dir, '_plugins', '*.rb')].each do |file|
          load file
        end
      end

      def constants
        Photish::Plugin.constants
      end

      def ignored_modules
        [Photish::Plugin::Repository,
         Photish::Plugin::Pluginable,
         Photish::Plugin::Type]
      end

      def constantize(symbol)
        Kernel.const_get("Photish::Plugin::#{symbol}")
      end
    end
  end
end
