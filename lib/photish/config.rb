require 'yaml'
require 'active_support'
require 'active_support/core_ext'

module Photish
  class Config
    def initialize(config_path, override_hash)
      config_hash = YAML.load_file(config_path).deep_symbolize_keys
      @config_hash = config_hash.merge(override_hash.deep_symbolize_keys)
    end

    def val(key)
      config_hash[key.to_sym]
    end

    private

    attr_reader :config_hash
  end
end
