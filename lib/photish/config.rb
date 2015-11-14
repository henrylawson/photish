require 'yaml'
require 'active_support'
require 'active_support/core_ext'

module Photish
  class Config
    def initialize(config_file_path)
      @config_file_path = config_file_path
      @config = config_file_hash
    end

    def val(key)
      @config[key.to_sym]
    end

    def override!(hash)
      @config.merge! hash.deep_symbolize_keys
    end

    private

    attr_reader :config_file_path

    def config_file_hash
      YAML.load_file(config_file_path).deep_symbolize_keys
    end
  end
end
