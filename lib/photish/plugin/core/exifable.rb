module Photish
  module Plugin
    module Core
      module Exifable
        def self.is_for?(type)
          Photish::Plugin::Type::Photo == type
        end

        def exif
          return @exif if @exif
          MiniExifTool.command = exiftool_path if exiftool_path
          @exif = MiniExiftool.new(path)
        end

        def exiftool_path
          config.dependencies.miniexiftool.command
        end
      end
    end
  end
end
