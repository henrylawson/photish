module Photish
  module Gallery
    module Traits
      module Metadatable
        def metadata
          return unless File.exist?(metadata_file)
          RecursiveOpenStruct.new(YAML.load_file(metadata_file))
        end

        private

        def basename
          File.basename(path, extname)
        end

        def extname
          File.extname(path)
        end

        def dirname
          File.dirname(path)
        end

        def metadata_file
          File.join(dirname, basename + '.yml')
        end
      end
    end
  end
end
