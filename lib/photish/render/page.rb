module Photish
  module Render
    class Page
      include Log::Loggable

      def initialize(layout_file, output_dir)
        @layout_file = layout_file
        @output_dir = output_dir
      end

      def render(pages)
        render_all(pages)
      end

      private

      attr_reader :layout_file,
                  :output_dir

      def render_all(pages)
        Array(pages).each do |page|
          rendered_model = render_with_layout(page)
          output_model_file = relative_to_output_dir(page.url_parts)
          output_model_dir = relative_to_output_dir(page.base_url_parts)

          log.debug "Rendering #{page.url} to #{output_model_file}"

          FileUtils.mkdir_p(output_model_dir)
          File.write(output_model_file, rendered_model)
        end
      end

      def relative_to_output_dir(url_parts)
        File.join(output_dir, url_parts)
      end

      def render_with_layout(page)
        layout.render(page) do
          Tilt.new(page.path).render(page)
        end
      end

      def layout
        @layout ||= Tilt.new(layout_file)
      end
    end
  end
end
