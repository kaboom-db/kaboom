# frozen_string_literal: true

class NavButtonComponent < ViewComponent::Base
  def initialize(href:, icon:, text:, active: false, mobile: false, method: :get)
    @href = href
    @icon = icon
    @text = text
    @active = active
    @mobile = mobile
    @method = method
  end
end
