# frozen_string_literal: true

class Actions::ActionsComponent < ViewComponent::Base
  def initialize(resource:, user:)
    @resource = resource
    @user = user
    @type = resource.class
  end

  def render?
    @user.present?
  end
end
