require "rails_helper"

RSpec.describe User, type: :model do
  describe "#avatar" do
    let(:user) { FactoryBot.create(:user, :confirmed, email: "hello@there.obi") }

    it "gets the avatar for the user from Gravatar" do
      expect(user.avatar).to eq "https://www.gravatar.com/avatar/898e4fc667e28813fe2ba58a7cec6286?d=retro"
    end
  end
end
