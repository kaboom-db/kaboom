# frozen_string_literal: true

class NavButtonComponent < ViewComponent::Base
  def initialize(href:, icon:, text:, active: false, mobile: false)
    @href = href
    @icon = icon
    @text = text
    @active = active
    @mobile = mobile
  end
end
