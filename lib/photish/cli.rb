require 'thor'
require 'photish/generation'
require 'photish/host'

module Photish
  class CLI < Thor
    package_name "Photish"

    desc "generate", "Generates the gallery static site"
    method_option :photo_dir,
                  aliases: "-p",
                  desc: "The directory where the photos live"
    method_option :site_dir,
                  aliases: "-s",
                  desc: "The location of the site config and template files"
    method_option :output_dir,
                  aliases: "-o",
                  desc: "The output directory where the generated site should go"
    def generate
      Photish::Generation.new(options).execute
    end

    desc "host", "Generates the gallery static site"
    method_option :photo_dir,
                  aliases: "-p",
                  desc: "The directory where the photos live"
    method_option :site_dir,
                  aliases: "-s",
                  desc: "The location of the site config and template files"
    method_option :output_dir,
                  aliases: "-o",
                  desc: "The output directory where the generated site should go"
    def host
      Photish::Host.new(options).execute
    end
  end
end

