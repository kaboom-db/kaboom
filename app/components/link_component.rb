# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  def initialize(text:, href:, data: {})
    @text = text
    @href = href
    @data = data
  end
end
