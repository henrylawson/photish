module Photish
  module Render
    class Site
      def initialize(config)
        @config = config
      end

      def all_for(collection)
        delete_unknown_files(collection.all_url_parts)
        delete_empty_folders
        move_non_ignored_site_contents
        collection_template.render(collection)
        render_asset_pages(collection)
      end

      private

      attr_reader :config

      delegate :templates,
               :site_dir,
               :output_dir,
               :worker_index,
               :url,
               :page_extension,
               to: :config

      def render_asset_pages(collection)
        AssetPage.new(collection,
                      output_dir,
                      site_dir).render(asset_page_paths)
      end

      def asset_page_paths
        Dir["#{site_dir}/**/*.#{page_extension}"].reject do |dir|
          dir.include? "#{File::SEPARATOR}_"
        end
      end

      def move_non_ignored_site_contents
        FileUtils.mkdir_p(output_dir)
        FileUtils.cp_r(non_ignored_site_contents,
                       File.join([output_dir, url.base].compact))
      end

      def delete_empty_folders
        Dir["#{output_dir}/**/"].reverse_each do |d|
          FileUtils.rm_rf(d) if empty_dir?(d)
        end
      end

      def empty_dir?(dir)
        Dir.entries(dir)
           .reject { |d| File.basename(d).starts_with?('.') }
           .empty?
      end

      def delete_unknown_files(url_parts)
        keep = Set.new(url_parts.map { |url| File.join(output_dir, url) }
                                .map(&:to_s))
        files_to_delete = Dir["#{output_dir}/**/*"].select do |f|
          File.file?(f) && !keep.include?(f)
        end
        FileUtils.rm_rf(files_to_delete)
      end

      def collection_template
        Template.new(layout_file,
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
