require 'yaml'
require 'active_support'
require 'active_support/core_ext'
require 'photish/default_config'

module Photish
  class Config
    def initialize(config_file_path)
      @config_file_path = config_file_path
      @config = DefaultConfig.hash 
      override!(config_file_hash)
    end

    def val(key)
      @config[key.to_sym]
    end

    def override!(hash)
      @config.merge!(clean(hash))
    end

    private

    attr_reader :config_file_path

    def config_file_hash
      clean(YAML.load_file(config_file_path))
    end

    def clean(hash)
      hash.compact.deep_symbolize_keys
    end
  end
end
