# frozen_string_literal: true

class UserHeroComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end
end
