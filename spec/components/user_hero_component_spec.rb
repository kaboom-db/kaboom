# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserHeroComponent, type: :component do
  it "renders the username" do
    user = FactoryBot.create(:user, username: "HeyThere")
    render_inline(described_class.new(user:))
    expect(page).to have_content "HeyThere"
  end

  it "renders the bio" do
    user = FactoryBot.create(:user, bio: "This is my bio!")
    render_inline(described_class.new(user:))
    expect(page).to have_content "This is my bio!"
  end

  context "when a possessive is specified" do
    it "adds the possessive to the title" do
      user = FactoryBot.create(:user, username: "HelloThereKenobi")
      render_inline(described_class.new(user:, possessive: "History"))
      expect(page).to have_content "HelloThereKenobi's History"
    end
  end
end
