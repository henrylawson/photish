module Photish
  module Gallery
    module Traits
      module Fileable
        def extension_of(file)
          File.extname(file)
              .split('.')
              .last
              .try(:downcase)
        end

        def extension
          extension_of(path)
        end

        def basename
          File.basename(path)
        end

        def basename_without_extension
          File.basename(path, '.*')
        end
      end
    end
  end
end
