module Photish
  module Render
    class Page
      def initialize(layout_file, template_file, output_dir)
        @layout_file = layout_file
        @template_file = template_file
        @output_dir = output_dir
        @log = Logging.logger[self]
      end

      def render(models)
        Array(models).each do |model|
          rendered_model = render_template_and_layout(model)
          output_model_file = relative_to_output_dir(model.url_parts)
          output_model_dir = relative_to_output_dir(model.base_url_parts)

          log.info "Rendering #{model.url} with template #{template_file} to #{output_model_file}"

          FileUtils.mkdir_p(output_model_dir)
          File.write(output_model_file, rendered_model)
        end
      end

      private

      attr_reader :template_file,
                  :layout_file,
                  :output_dir,
                  :log

      def relative_to_output_dir(url_parts)
        File.join(output_dir, url_parts)
      end

      def render_template_and_layout(model)
        layout.render(model) do
          template.render(model)
        end
      end

      def template
        @template ||= Tilt.new(template_file)
      end

      def layout
        @layout ||= Tilt.new(layout_file)
      end
    end
  end
end
