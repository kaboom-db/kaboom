# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfileChipComponent, type: :component do
  it "renders the component" do
    user = FactoryBot.create(:user, username: "TestUser", created_at: Time.new(2024, 1, 1, 10, 0, 0, "+00:00"))
    render_inline(described_class.new(user:))
    expect(page).to have_content "TestUser"
    expect(page).to have_content "Member since: 1 Jan 2024 10:00"
    expect(page).to have_css "img[src='#{user.avatar}']"
  end
end
