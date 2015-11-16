module Photish
  module Gallery
    module Traits
      module SubGroupable
        def sub_groups(clazz)
          @sub_groups ||= Dir.entries(path)
                             .reject { |file| ['.', '..'].include?(file) }
                             .map    { |file| File.join(path, file) }
                             .reject { |file| !Dir.exist?(file) }
                             .map    { |file| clazz.new(self, file) }
        end
      end
    end
  end
end
