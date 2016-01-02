module Photish
  module Plugin
    module Core
      module Exifable
        def self.is_for?(type)
          Photish::Plugin::Type::Photo == type
        end

        def exif
          @exif ||= MiniExiftool.new(path)
        end
      end
    end
  end
end
