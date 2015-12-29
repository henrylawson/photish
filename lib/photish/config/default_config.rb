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
        ImageExtension::IMAGE_MAGICK
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
