# frozen_string_literal: true

class UserHeroComponent < ViewComponent::Base
  def initialize(user:, possessive: nil)
    @user = user
    @possessive = possessive
  end
end
