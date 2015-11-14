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
      cleaned_hash = compact_symbolize(hash)
      config.merge!(cleaned_hash)
    end

    private

    attr_reader :config_file_path

    def config
      @config ||= default_config.merge(file_config)
    end

    def default_config
      DefaultConfig.hash
    end

    def file_config
      compact_symbolize(YAML.load_file(config_file_path))
    end

    def compact_symbolize(hash)
      hash
        .compact
        .deep_symbolize_keys
    end
  end
end
