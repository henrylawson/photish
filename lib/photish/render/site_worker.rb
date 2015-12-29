module Photish
  module Render
    class SiteWorker
      def initialize(config, version_hash)
        @config = config
        @version_hash = version_hash
      end

      def all_for(collection)
        tasks(collection).shuffle.each(&:call)
      end

      private

      attr_reader :config,
                  :version_hash

      delegate :templates,
               :site_dir,
               :output_dir,
               :workers,
               :worker_index,
               to: :config

      def tasks(collection)
        [
          ->{ album_template.render(subset(collection.all_albums))   },
          ->{ photo_template.render(subset(collection.all_photos))   },
          ->{ image_conversion.render(subset(collection.all_images)) },
        ]
      end

      def subset(items)
        worker_index_zeroed.step(items.count, workers)
                           .map { |i| items[i] }
                           .compact
      end

      def image_conversion
        ImageConversion.new(config, version_hash)
      end

      def album_template
        Page.new(layout_file,
                 template_album_file,
                 output_dir)
      end

      def photo_template
        Page.new(layout_file,
                 template_photo_file,
                 output_dir)
      end

      def layout_file
        File.join(site_dir, templates_dir, templates.layout)
      end

      def template_album_file
        File.join(site_dir,  templates_dir, templates.album)
      end

      def template_photo_file
        File.join(site_dir, templates_dir, templates.photo)
      end

      def templates_dir
        '_templates'
      end

      def worker_index_zeroed
        worker_index - 1
      end
    end
  end
end
