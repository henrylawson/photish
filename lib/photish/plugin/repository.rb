module Photish
  module Plugin
    class Repository
      include Singleton
      include Log::Loggable

      def reload(config)
        log.debug "Loading plugins..."

        load_each_plugin_file(config.site_dir)
        require_each_explicit_plugin(config.plugins)
        clear_plugin_cache
        load_each_plugin_constant
      end

      def plugins_for(type)
        all_plugins.reject { |m| !m.is_for?(type) }
      end

      def all_plugins
        @all_plugins ||= constants + sub_constants
      end

      def loaded?
        @all_plugins.present?
      end

      private

      def require_each_explicit_plugin(plugins)
        plugins.each do |plugin|
          log.debug "Requiring config explicit plugin, #{plugin}"
          require plugin
        end
      end

      def load_each_plugin_constant
        all_plugins.each do |plugin|
          log.debug "Found plugin #{plugin}"
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
        Photish::Plugin.constants.map    { |m| constantize(m) }
                                 .reject { |m| ignored_modules.include?(m) }
                                 .select { |m| m.respond_to?(:is_for?) }
      end

      def sub_constants
        Photish::Plugin.constants.map    { |c| constantize(c) }
                                 .reject { |m| ignored_modules.include?(m) }
                                 .map    { |c| c.constants.map { |d| constantize("#{c.name}::#{d}") } }
                                 .flatten
                                 .select { |m| m.respond_to?(:is_for?) }
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
