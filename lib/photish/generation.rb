require 'photish/log'
require 'photish/config'
require 'photish/config_location'

module Photish
  class Generation
    include Photish::Log

    def initialize(photo_dir, site_dir, output_dir)
      config_location = ConfigLocation.new(site_dir)
      @config = Config.new(config_location.path)
      @config.override!({
        photo_dir: photo_dir,
        site_dir: site_dir,
        output_dir: output_dir
      })
    end

    def execute
      log "Photo directory: #{config.val(:photo_dir)}"
      log "Site directory: #{config.val(:site_dir)}"
      log "Output directory: #{config.val(:output_dir)}"
    end

    private

    attr_reader :config
  end
end
