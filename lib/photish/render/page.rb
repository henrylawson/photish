require 'tilt'

module Photish
  module Render
    class Page
      def initialize(template_file, output_dir)
        @template = Tilt.new(template_file)
        @output_dir = output_dir
      end

      def render(models)
        Array(models).each do |model|
          rendered_model = template.render(model)
          FileUtils.mkdir_p(File.join(output_dir, model.base_url_parts))
          output_file = File.join(output_dir, model.url_parts)
          File.write(output_file, rendered_model)
        end
      end

      private

      attr_reader :template,
                  :output_dir
    end
  end
end
