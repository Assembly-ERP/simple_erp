# frozen_string_literal: true

module FormBuilderHelper
  class ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    def quill_snow_text_area(name, _options = {})
      content_tag :div, class: 'min-h-[204px]', data: { controller: 'quill' } do
        content_tag(:div, ActionController::Base.helpers.sanitize(object[name]),
                    data: { 'quill-target': 'editor' }) << hidden_field(name, data: { 'quill-target': 'input' })
      end
    end
  end
end
