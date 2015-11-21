require 'photish/log'
require 'photish/config/app_settings'
require 'photish/gallery/collection'
require 'photish/render/site'
require 'tilt'

module Photish
  class Generation
    include Photish::Log

    def initialize(runtime_config)
      @config = Photish::Config::AppSettings.new(runtime_config)
                                            .config
    end

    def execute
      log_important_config_values
      log_album_and_photo_names
      render_site
    end

    private

    attr_reader :config

    def log_important_config_values
      log "Photo directory: #{photo_dir}"
      log "Site directory: #{site_dir}"
      log "Output directory: #{output_dir}"
    end

    def log_album_and_photo_names
      collection.albums.each do |album|
        log album.name
        log album.photos.map(&:name)
      end
    end

    def render_site
      Photish::Render::Site.new(collection, site_dir, output_dir)
                           .all
    end

    def photo_dir
      config.val(:photo_dir)
    end

    def output_dir
      config.val(:output_dir)
    end

    def site_dir
      config.val(:site_dir)
    end

    def collection
      @collection ||= Gallery::Collection.new(photo_dir)
    end
  end
end
