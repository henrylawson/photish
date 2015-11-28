require 'photish/plugin/type'

module Photish
  module Plugin
    module Pluginable
      def initialize(*args)
        plugins_for(self.plugin_type).each do |moduol|
          self.class.send(:include, moduol)
        end
      end
      
      private

      def plugins_for(type)
        Photish::Plugin.constants.map    { |m| constantize(m) }
                                 .reject { |m| ignored_modules.include?(m) }
                                 .reject { |m| !m.is_for?(type) }
      end

      def ignored_modules
        [Photish::Plugin::Pluginable, Photish::Plugin::Type]
      end

      def constantize(symbol)
        Kernel.const_get("Photish::Plugin::#{symbol}")
      end
    end
  end
end
