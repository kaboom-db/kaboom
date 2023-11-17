require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /show" do
    let(:user) { FactoryBot.create(:user, username: "Obi1", confirmed_at:) }

    context "when user is not confirmed" do
      let(:confirmed_at) { nil }

      it "renders 404" do
        expect { get user_path(user) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is confirmed" do
      let(:confirmed_at) { Time.current }

      it "renders a successful response" do
        get user_path(user)
        expect(response).to be_successful
      end

      it "displays the username" do
        get user_path(user)
        assert_select "h1", text: "Obi1"
      end
    end
  end
end
