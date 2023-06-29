# frozen_string_literal: true

class TextInputComponent < ViewComponent::Base
  def initialize(name:, placeholder: nil)
    @name = name
    @placeholder = placeholder || name.humanize
  end
end
