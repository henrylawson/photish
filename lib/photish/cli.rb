require 'thor'
require 'photish/generation'
require 'photish/host'
require 'photish/init'

module Photish
  class CLI < Thor
    package_name "Photish"

    desc "generate", "Generates the gallery static site"
    def generate
      Photish::Generation.new(options).execute
    end

    desc "host", "Serves the HTML on a HTTP server at http://localhost:9876/"
    def host
      Photish::Host.new(options).execute
    end

    desc "init", "Creates a basic Photish site sctructure"
    def init
      Photish::Init.new(options).execute
    end
  end
end

