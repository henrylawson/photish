module Photish
  module Config
    class DefaultConfig
      def hash
        {
          port: 9876,
          site_dir: File.join(Dir.pwd, 'site'),
          photo_dir: File.join(Dir.pwd, 'photos'),
          output_dir: File.join(Dir.pwd, 'output'),
          workers: workers,
          threads: threads,
          worker_index: 0,
          force: false,
          photish_executable: photish_executable,
          qualities: qualities,
          templates: templates,
          logging: logging,
          url: url,
          plugins: [],
          image_extensions: image_extensions,
          soft_failure: false
        }
      end

      private

      def image_extensions
        ['aai', 'art', 'avs', 'bgr', 'bgra', 'bgro', 'bmp', 'bmp2', 'bmp3', 'brf', 'cal', 'cals', 'canvas', 'caption', 'cin', 'cip', 'clip', 'cmyk', 'cmyka', 'cur', 'cut', 'data', 'dcm', 'dcx', 'dds', 'dfont', 'dpx', 'dxt1', 'dxt5', 'eps2', 'eps3', 'fax', 'fits', 'fractal', 'fts', 'g3', 'gif', 'gif87', 'gradient', 'gray', 'group4', 'h', 'hald', 'hdr', 'histogram', 'hrz', 'htm', 'html', 'icb', 'ico', 'icon', 'inline', 'ipl', 'isobrl', 'isobrl6', 'jng', 'jnx', 'jpe', 'jpeg', 'jpg', 'jps', 'label', 'mac', 'magick', 'map', 'mask', 'matte', 'miff', 'mng', 'mono', 'mpc', 'msl', 'mtv', 'mvg', 'null', 'otb', 'otf', 'pal', 'palm', 'pam', 'pango', 'pattern', 'pbm', 'pcd', 'pcds', 'pct', 'pcx', 'pdb', 'pes', 'pfa', 'pfb', 'pfm', 'pgm', 'picon', 'pict', 'pix', 'pjpeg', 'plasma', 'png', 'png00', 'png24', 'png32', 'png48', 'png64', 'png8', 'pnm', 'ppm', 'preview', 'ps2', 'ps3', 'psb', 'psd', 'ptif', 'pwp', 'radial-gradient', 'ras', 'rgb', 'rgba', 'rgbo', 'rgf', 'rla', 'rle', 'scr', 'sct', 'sfw', 'sgi', 'shtml', 'six', 'sixel', 'sparse-color', 'stegano', 'sun', 'text', 'tga', 'thumbnail', 'tiff', 'tiff64', 'tile', 'tim', 'ttc', 'ttf', 'ubrl', 'ubrl6', 'uil', 'uyvy', 'vda', 'vicar', 'vid', 'viff', 'vips', 'vst', 'wbmp', 'wpg', 'xbm', 'xc', 'xcf', 'xpm', 'xv', 'ycbcr', 'ycbcra', 'yuv']
      end

      def url
        {
          host: '',
          base: nil,
          type: 'absolute_uri'
        }
      end

      def logging
        {
          colorize: true,
          output: ['stdout', 'file'],
          level: 'debug'
        }
      end

      def templates
        {
          layout: 'layout.slim',
          collection: 'collection.slim',
          album: 'album.slim',
          photo: 'photo.slim'
        }
      end

      def qualities
        [
          { name: 'Original',
            params: [] },
          { name: 'Low',
            params: ['-resize', '200x200'] }
        ]
      end

      def workers
        1
      end

      def threads
        processor_count
      end

      def processor_count
        Facter.value('processors')['count']
      end

      def photish_executable
        File.join(File.dirname(__FILE__),
                  '..',
                  '..',
                  '..',
                  'exe',
                  'photish')
      end
    end
  end
end
