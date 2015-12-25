module Photish
  module Plugin
    module Pluginable
      def initialize(*_args)
        plugins_for_type.each do |moduol|
          self.class.send(:include, moduol)
        end
      end

      def plugins_for_type
        Photish::Plugin::Repository.instance
                                   .plugins_for(self.plugin_type)
      end
    end
  end
end
