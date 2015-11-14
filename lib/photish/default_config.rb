module Photish
  class DefaultConfig
    def self.hash
      {
        site_dir: File.join(Dir.pwd, 'site'),
        photo_dir: File.join(Dir.pwd, 'photos'),
        output_dir: File.join(Dir.pwd, 'output')
      }
    end
  end
end
