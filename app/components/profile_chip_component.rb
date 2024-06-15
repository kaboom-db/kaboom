# frozen_string_literal: true

class ProfileChipComponent < ViewComponent::Base
  def initialize(user:, in_dialog: false)
    @user = user
    @in_dialog = in_dialog
  end
end
