# frozen_string_literal: true

class Forms::SubmitComponent < ViewComponent::Base
  def initialize(form:, text:)
    @form = form
    @text = text
  end
end
