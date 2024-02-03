# frozen_string_literal: true

class Forms::TextFieldComponent < ViewComponent::Base
  def initialize(form:, field:, type: "text_field", autofocus: false, required: false, placeholder: nil, extras: {})
    @field = field
    @form = form
    @placeholder = placeholder || field.to_s.humanize
    @type = type
    @autofocus = autofocus
    @required = required
    @extras = extras
  end
end
