
module Photish
  module Plugin
    module Repository
      class << self
        def plugins_for(type)
          all_plugins.reject { |m| !m.is_for?(type) }
        end

        def all_plugins
          Photish::Plugin.constants.map    { |m| constantize(m) }
                                   .reject { |m| ignored_modules.include?(m) }
        end
        
        private

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
end
