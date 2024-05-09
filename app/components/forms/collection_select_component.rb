# frozen_string_literal: true

class Forms::CollectionSelectComponent < ViewComponent::Base
  def initialize(form:, field:, options:, identifier: :to_s, include_blank: true, multiple: false, label_text: nil)
    @form = form
    @field = field
    @options = options
    @identifier = identifier
    @include_blank = include_blank
    @multiple = multiple
    @label_text = label_text
  end
end
