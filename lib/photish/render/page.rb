module Photish
  module Render
    class Page
      include Log::Loggable

      def initialize(layout_file, template_file, output_dir)
        @layout_file = layout_file
        @template_file = template_file
        @output_dir = output_dir
      end

      def render(models)
        return template_missing unless File.exist?(template_file)
        render_all(models)
      end

      private

      attr_reader :template_file,
                  :layout_file,
                  :output_dir

      def render_all(models)
        Array(models).each do |model|
          rendered_model = render_template_and_layout(model)
          output_model_file = relative_to_output_dir(model.url_parts)
          output_model_dir = relative_to_output_dir(model.base_url_parts)

          log.debug "Rendering #{model.url} with template #{template_file} to #{output_model_file}"

          FileUtils.mkdir_p(output_model_dir)
          File.write(output_model_file, rendered_model)
        end
      end

      def template_missing
        log.debug "Template not found #{template_file}, skipping rendering"
      end

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
