module Photish
  module Render
    class AssetPage
      include Log::Loggable

      def initialize(collection, output_dir, site_dir)
        @collection = collection
        @output_dir = output_dir
        @site_dir = site_dir
      end

      def render(page_paths)
        render_all(page_paths)
      end

      private

      attr_reader :collection,
                  :output_dir,
                  :site_dir

      def render_all(page_paths)
        Array(page_paths).each do |page_path|
          rendered_model = render_page(page_path)
          output_model_file = relative_to_output_dir(page_path)
          output_model_dir = File.dirname(output_model_file)

          log.debug "Rendering #{page_path} to #{output_model_file}"

          FileUtils.mkdir_p(output_model_dir)
          File.write(output_model_file, rendered_model)
        end
      end

      def relative_to_output_dir(page_path)
        relative_path = page_path.gsub(site_dir, '')
        basename = File.basename(relative_path, File.extname(relative_path))
        a = File.join(output_dir, File.dirname(relative_path), basename)
        puts a
        a
      end

      def render_page(page_path)
        Tilt.new(page_path).render(collection)
      end
    end
  end
end
