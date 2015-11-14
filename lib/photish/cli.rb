require 'thor'
require 'photish/generation'

module Photish
  class CLI < Thor
    package_name "Photish"

    desc "generate", "Generates the gallery static site"
    method_option :photo_dir,
                  aliases: "-pd",
                  desc: "The directory where the photos live"
    method_option :site_dir,
                  aliases: "-sd",
                  desc: "The location of the site config and template files"
    method_option :output_dir,
                  aliases: "-od",
                  desc: "The output directory where the generated site should go"
    def generate
      puts Photish::Generation.new(
        options[:photo_dir],
        options[:site_dir],
        options[:output_dir]).execute
    end
  end
end

