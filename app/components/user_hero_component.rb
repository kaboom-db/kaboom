# frozen_string_literal: true

class UserHeroComponent < ViewComponent::Base
  def initialize(user:, possessive: nil)
    @user = user
    @last_read_issue = user.last_read_issue
    @possessive = possessive
  end
end
