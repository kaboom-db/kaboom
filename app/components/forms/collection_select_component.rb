# frozen_string_literal: true

class Forms::CollectionSelectComponent < ViewComponent::Base
  def initialize(form:, field:, options:, identifier: :to_s, include_blank: true, multiple: false)
    @form = form
    @field = field
    @options = options
    @identifier = identifier
    @include_blank = include_blank
    @multiple = multiple
  end
end
