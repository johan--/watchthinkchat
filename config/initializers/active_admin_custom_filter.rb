# From https://gist.github.com/rdj/1057991
# From `filter :foo, as: :custom` for ActiveAdmin
module ActiveAdmin
  module Inputs
    class FilterCustomInput < ::Formtastic::Inputs::StringInput
      include FilterBase

      def to_html
        input_wrapping do
          id = input_html_options[:id].split("q_").second
          value = self.builder.template.controller.params[:q].try(:[], id)
          label_html << builder.text_field(input_name, input_html_options.merge("value" => value))
        end
      end

      def label_text
        options[:label]
      end

      def input_name
        "#{super}"
      end
    end
  end
end
