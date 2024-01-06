require "rails_helper"

RSpec.describe "Statistics", type: :request do
  let(:user) { FactoryBot.create(:user, :confirmed) }

  describe "GET /index" do
    it "renders a successful response" do
      get user_statistics_path(user_id: user.username)
      expect(response).to be_successful
    end

    it "renders the alltime stats page" do
      get user_statistics_path(user_id: user.username)
      assert_select "h1.text-primary", text: "Alltime Statistics"
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get user_statistic_path("2023", user_id: user.username)
      expect(response).to be_successful
    end

    it "renders the stats for that year" do
      get user_statistic_path("2023", user_id: user.username)
      assert_select "h1.text-primary", text: "2023 Statistics"
    end

    context "when year param is not a valid year" do
      it "returns a 404" do
        get user_statistic_path("bogus", user_id: user.username)
        expect(response.status).to eq 404
      end
    end

    context "when year param is alltime" do
      it "renders the alltime stats page" do
        get user_statistic_path("alltime", user_id: user.username)
        assert_select "h1.text-primary", text: "Alltime Statistics"
      end
    end
  end
end
