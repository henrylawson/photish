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
          photish_executable: photish_executable,
          qualities: [
            { name: 'Original',
              params: [] },
            { name: 'Low',
              params: ['-resize', '200x200'] }
          ],
          templates: {
            layout: 'layout.slim',
            collection: 'collection.slim',
            album: 'album.slim',
            photo: 'photo.slim'
          },
          logging: {
            colorize: true,
            output: ['stdout', 'file'],
            level: 'info'
          },
          url: {
            host: '',
            base: nil
          }
        }
      end

      private

      def workers
        processor_count / 2
      end

      def threads
        2
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
