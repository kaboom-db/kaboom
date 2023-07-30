# frozen_string_literal: true

class PageTitleComponent < ViewComponent::Base
  def initialize(text:)
    @text = text
  end
end
