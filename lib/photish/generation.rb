require 'photish/log'

module Photish
  class Generation
    include Photish::Log

    def initialize(photo_dir, site_dir, output_dir)
      @photo_dir = photo_dir
      @site_dir = site_dir
      @output_dir = output_dir
    end

    def execute
      log "Photo directory: #{photo_dir}"
      log "Site directory: #{site_dir}"
      log "Output directory: #{output_dir}"
    end

    private

    attr_reader :photo_dir,
                :site_dir,
                :output_dir
  end
end
