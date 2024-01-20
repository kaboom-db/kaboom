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

  context "when there is a last read issue" do
    it "renders the name of the issue and comic with the read at" do
      user = FactoryBot.create(:user, username: "HelloThereKenobi")
      comic = FactoryBot.create(:comic, name: "Test Comic")
      issue = FactoryBot.create(:issue, name: "Test Issue", comic:)
      FactoryBot.create(:read_issue, issue:, user:, read_at: Time.new(2024, 1, 1, 10, 0, 0, "+00:00"))
      render_inline(described_class.new(user:))
      expect(page).to have_content "HelloThereKenobi last read Test Issue of Test Comic at 1 Jan 10:00"
    end
  end
end
