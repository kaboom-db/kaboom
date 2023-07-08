# frozen_string_literal: true

class Actions::ActionsComponent < ViewComponent::Base
  def initialize(resource:, user:)
    @resource = resource
    @user = user
  end

  def render?
    @user.present?
  end
end
