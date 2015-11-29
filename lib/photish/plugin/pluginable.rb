module Photish
  module Plugin
    module Pluginable
      def initialize(*_args)
        Photish::Plugin::Repository.plugins_for(self.plugin_type).each do |moduol|
          self.class.send(:include, moduol)
        end
      end
    end
  end
end
