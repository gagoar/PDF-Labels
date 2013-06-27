require File.expand_path(File.dirname(__FILE__) + '/template')
module Pdf
  module Label
    class GlabelsTemplate
      include XML::Mapping

      hash_node :templates, "Template", "@name", class: Template, default_value: Hash.new

      def find_all_templates
        unless @templates
          @templates = []
          templates.each do |template|
           template = template[1]
            @templates << template[1].name
            template.alias.each do |aliases|
              @templates << aliases[1].name
            end
          end
        end
        @templates
      end

      def find_template(template_name)
        if template_name != :all
          if ( template = templates[template_name] )
            template
          else
            templates.each do |template|
              return template[1] if template[1].alias[template_name]
            end
          end
        else
          find_all_with_templates
        end
      end
    end
  end
end
