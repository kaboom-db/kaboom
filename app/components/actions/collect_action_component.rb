# frozen_string_literal: true

class Actions::CollectActionComponent < ViewComponent::Base
  def initialize(resource:, user:)
    @resource = resource
    @user = user
  end
end
