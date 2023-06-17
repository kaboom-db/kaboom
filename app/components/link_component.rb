# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(text:, href:)
    @text = text
    @href = href
  end
end
