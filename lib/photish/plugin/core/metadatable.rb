module Photish
  module Plugin
    module Core
      module Metadatable
        def self.is_for?(type)
          [
            Photish::Plugin::Type::Collection,
            Photish::Plugin::Type::Album,
            Photish::Plugin::Type::Photo,
            Photish::Plugin::Type::Page,
          ].include?(type)
        end

        def metadata
          return unless File.exist?(metadata_file)
          @metadata ||= RecursiveOpenStruct.new(YAML.load_file(metadata_file))
        end

        private

        def metadata_file
          File.join(dirname, basename_without_extension + '.yml')
        end
      end
    end
  end
end
