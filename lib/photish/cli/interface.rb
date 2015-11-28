require 'thor'
require 'photish/command/generate'
require 'photish/command/host'
require 'photish/command/init'

module Photish
  module CLI
    class Interface < Thor
      package_name "Photish"

      desc "generate", "Generates the gallery static site"
      def generate
        Photish::Command::Generate.new(options).execute
      end

      desc "host", "Serves the HTML on a HTTP server"
      def host
        Photish::Command::Host.new(options).execute
      end

      desc "init", "Creates a basic Photish site structure"
      def init
        Photish::Command::Init.new(options).execute
      end
    end
  end
end

