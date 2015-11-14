require 'yaml'

module Photish
  class Config
    def initialize(config_path)
      @file_hash = YAML.load_file(config_path)
    end

    def val(key, override = nil)
      override || file_hash[key.to_s]
    end

    private

    attr_reader :file_hash
  end
end
