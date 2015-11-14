require 'yaml'
require 'active_support'
require 'active_support/core_ext'
require 'photish/default_config'

module Photish
  class Config
    def initialize(config_file_path)
      @config_file_path = config_file_path
    end

    def val(key)
      config[key.to_sym]
    end

    def override!(hash)
      cleaned_hash = clean(hash)
      config.merge!(cleaned_hash)
    end

    private

    attr_reader :config_file_path

    def config
      @config ||= default_config_hash.merge(config_file_hash)
    end

    def default_config_hash
      DefaultConfig.hash
    end

    def config_file_hash
      clean(YAML.load_file(config_file_path))
    end

    def clean(hash)
      hash.compact.deep_symbolize_keys
    end
  end
end
