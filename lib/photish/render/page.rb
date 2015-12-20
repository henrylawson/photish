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
        return template_missing unless File.exist?(template_file)
        return no_changes unless changed?(template_file) || changed?(layout_file)
        render_all(models)
      end

      private

      attr_reader :template_file,
                  :layout_file,
                  :output_dir,
                  :log

      delegate :record,
               :changed?,
               :flush_to_disk,
               to: :change_manifest

      def render_all(models)
        Array(models).each do |model|
          rendered_model = render_template_and_layout(model)
          output_model_file = relative_to_output_dir(model.url_parts)
          output_model_dir = relative_to_output_dir(model.base_url_parts)

          log.info "Rendering #{model.url} with template #{template_file} to #{output_model_file}"

          FileUtils.mkdir_p(output_model_dir)
          File.write(output_model_file, rendered_model)
        end

        record(template_file)
        record(layout_file)
        flush_to_disk
      end

      def template_missing
        log.info "Template not found #{template_file}, skipping rendering"
      end

      def no_changes
        log.info "No changes for template or layout, skipping rendering"
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

      def change_manifest
        @change_manifest ||= ChangeManifest.new(output_dir)
      end
    end
  end
end
