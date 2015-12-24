module Photish
  module Plugin
    class Repository
      include Singleton

      class << self
        def reload(log, site_dir)
          self.instance.reload(log, site_dir)
        end

        def plugins_for(type)
          self.instance.plugins_for(type)
        end

        def loaded?
          self.instance.loaded?
        end
      end

      def reload(log, site_dir)
        log.info "Loading plugins..."
        Dir[File.join(site_dir, '_plugins', '*.rb')].each do |file|
          load file
        end

        @all_plugins = nil

        all_plugins.each do |plugin|
          log.info "Found plugin #{plugin}"
        end
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
