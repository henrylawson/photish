module Photish
  module Render
    class Site
      def initialize(config)
        @config = config
      end

      def all_for(collection)
        delete_unknown_files(collection.all_url_parts)
        move_non_ignored_site_contents
        collection_template.render(collection)
      end

      private

      attr_reader :config

      delegate :templates,
               :site_dir,
               :output_dir,
               :worker_index,
               :url,
               to: :config

      def move_non_ignored_site_contents
        FileUtils.mkdir_p(output_dir)
        FileUtils.cp_r(non_ignored_site_contents,
                       File.join([output_dir, url.base].flatten))
      end

      def delete_unknown_files(url_parts)
        do_not_delete = Set.new(url_parts.map { |url| File.join(output_dir, url) }
                                         .map(&:to_s))
        files_to_delete = Dir["#{output_dir}/**/*"].select do |f|
          File.file?(f) && !do_not_delete.include?(f)
        end
        FileUtils.rm_rf(files_to_delete)
      end

      def collection_template
        Page.new(layout_file,
                 template_collection_file,
                 output_dir)
      end

      def non_ignored_site_contents
        Dir.glob(File.join(site_dir, '[!_]*'))
      end

      def layout_file
        File.join(site_dir, templates_dir, templates.layout)
      end

      def template_collection_file
        File.join(site_dir, templates_dir, templates.collection)
      end

      def templates_dir
        '_templates'
      end
    end
  end
end
