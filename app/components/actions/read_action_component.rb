# frozen_string_literal: true

class Actions::ReadActionComponent < ViewComponent::Base
  def initialize(resource:, user:)
    @resource = resource
    @user = user

    @is_read = user.issues_read.include?(resource)
  end
end
