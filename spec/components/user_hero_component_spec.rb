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
end
