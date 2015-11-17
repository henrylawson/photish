require 'photish/log'
require 'photish/config/settings'
require 'photish/config/location'
require 'photish/gallery/collection'
require 'tilt'

module Photish
  class Generation
    include Photish::Log

    def initialize(runtime_config)
      @runtime_config = runtime_config
    end

    def execute
      log_important_config_values
      log_album_and_photo_names

      write_rendered_index_page
      write_rendered_album_pages
      write_rendered_photo_pages
    end

    private

    attr_reader :runtime_config

    def log_important_config_values
      log "Photo directory: #{config.val(:photo_dir)}"
      log "Site directory: #{config.val(:site_dir)}"
      log "Output directory: #{config.val(:output_dir)}"
    end

    def log_album_and_photo_names
      collection.albums.each do |album|
        log album.name
        log album.photos.map(&:name)
      end
    end

    def write_rendered_album_pages
      collection.albums.each do |album|
        rendered_album = Tilt.new(template_album_file).render(album)
        FileUtils.mkdir_p(File.join(config.val(:output_dir), album.base_url_parts))
        output_album_file = File.join(config.val(:output_dir), album.url_parts)
        File.write(output_album_file, rendered_album)
      end
    end

    def write_rendered_photo_pages
      collection.albums.map(&:photos).flatten.each do |photo|
        rendered_photo = Tilt.new(template_photo_file).render(photo)
        FileUtils.mkdir_p(File.join(config.val(:output_dir), photo.base_url_parts))
        output_photo_file = File.join(config.val(:output_dir), photo.url_parts)
        File.write(output_photo_file, rendered_photo)
      end
    end

    def write_rendered_index_page
      FileUtils.mkdir_p(config.val(:output_dir))
      File.write(output_index_file, rendered_index)
    end

    def rendered_index
      Tilt.new(template_index_file).render(collection)
    end

    def template_index_file
      File.join(config.val(:site_dir), 'index.slim')
    end

    def template_album_file
      File.join(config.val(:site_dir), 'album.slim')
    end

    def template_photo_file
      File.join(config.val(:site_dir), 'photo.slim')
    end

    def output_index_file
      File.join(config.val(:output_dir), collection.url_parts)
    end

    def collection
      @colleciton ||= Gallery::Collection.new(config.val(:photo_dir))
    end

    def config
      @config ||= Config::Settings
        .new(default_config)
        .override(file_config)
        .override(runtime_config)
    end

    def file_config
      config_location = Config::Location.new(runtime_config[:site_dir])
      Config::FileConfig.new(config_location.path).hash
    end

    def default_config
      Config::DefaultConfig.new.hash
    end
  end
end
