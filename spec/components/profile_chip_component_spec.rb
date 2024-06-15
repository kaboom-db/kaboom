# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProfileChipComponent, type: :component do
  let(:user) { FactoryBot.create(:user, username: "TestUser2", created_at: Time.new(2024, 1, 1, 10, 0, 0, "+00:00")) }

  it "renders the component" do
    render_inline(described_class.new(user:))
    expect(page).to have_content "TestUser"
    expect(page).to have_content "Member since: 1 Jan 2024 10:00"
    expect(page).to have_css "img[src='#{user.avatar}']"
    expect(page).to have_css "div[class='hidden md:block']"
  end

  context "when in_dialog is true" do
    it "does not render the responsive version" do
      render_inline(described_class.new(user:, in_dialog: true))
      expect(page).to have_css "div[class='block']"
    end
  end
end
