require 'tilt'

module Photish
  module Render
    class Page

      include Photish::Log

      def initialize(layout_file, template_file, output_dir)
        @layout_file = layout_file
        @template_file = template_file
        @output_dir = output_dir
      end

      def render(models)
        Array(models).each do |model|
          rendered_model = render_template_and_layout(model)
          FileUtils.mkdir_p(File.join(output_dir, model.base_url_parts))
          output_file = File.join(output_dir, model.url_parts)
          log "Rendering #{model.url} with template #{template_file} to #{output_file}"
          File.write(output_file, rendered_model)
        end
      end

      private

      attr_reader :template_file,
                  :layout_file,
                  :output_dir

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
