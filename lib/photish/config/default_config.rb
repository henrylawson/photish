module Photish
  module Config
    class DefaultConfig
      def hash
        {
          site_dir: File.join(Dir.pwd, 'site'),
          photo_dir: File.join(Dir.pwd, 'photos'),
          output_dir: File.join(Dir.pwd, 'output'),
          port: 9882
        }
      end
    end
  end
end
