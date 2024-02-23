# frozen_string_literal: true

class ProfileChipComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end
end
