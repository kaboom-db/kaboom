# frozen_string_literal: true

class UserHeroComponent < ViewComponent::Base
  def initialize(user:, current_user:, possessive: nil)
    @user = user
    @last_read_issue = user.last_read_issue
    @current_user = current_user
    @possessive = possessive
  end

  private

  def should_show_extra_info?
    @user == @current_user || !@user.private?
  end
end
