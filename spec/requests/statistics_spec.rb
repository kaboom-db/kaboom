require "rails_helper"

RSpec.describe "Statistics", type: :request do
  let(:user) { FactoryBot.create(:user, :confirmed, username: "TestUser") }

  shared_examples_for "a statistics page" do
    it "renders the read and collected counts" do
      get path
      assert_select "h2.text-2xl", text: "Issues read and collected"
    end

    context "when there are no read or collected issues" do
      it "renders the first read and collected sections" do
        get path
        assert_select "h2.text-2xl", text: "No issues read"
        assert_select "h2.text-2xl", text: "No issues collected"
      end

      it "renders the main issue counts" do
        get path
        assert_select "p.text-4xl", text: "0", count: 2
      end
    end

    context "when there are read or collected issues" do
      before do
        issue1 = FactoryBot.create(:issue, name: "I'm a read issue")
        issue2 = FactoryBot.create(:issue, name: "I'm a collected issue")
        FactoryBot.create(:read_issue, issue: issue1, user:, read_at: Time.new(2023, 1, 2, 0, 0))
        FactoryBot.create(:collected_issue, issue: issue2, user:, collected_on: Date.new(2023, 1, 2))
        get path
      end

      it "renders the first read and collected sections" do
        assert_select "h2.text-2xl", text: "First read"
        assert_select "h2.text-2xl", text: "I'm a read issue"
        assert_select "h2.text-2xl", text: "First collected"
        assert_select "h2.text-2xl", text: "I'm a collected issue"
      end

      it "renders the main issue counts" do
        assert_select "p.text-4xl", text: "1", count: 2
      end
    end
  end

  describe "GET /index" do
    let(:path) { user_statistics_path(user_id: user.username) }

    it "renders a successful response" do
      get path
      expect(response).to be_successful
    end

    it "renders the alltime stats page" do
      get path
      assert_select "div.text-2xl", text: "TestUser's Alltime Statistics"
    end

    it_behaves_like "a statistics page"
  end

  describe "GET /show" do
    let(:path) { user_statistic_path("2023", user_id: user.username) }

    it "renders a successful response" do
      get path
      expect(response).to be_successful
    end

    it "renders the stats for that year" do
      get path
      assert_select "div.text-2xl", text: "TestUser's 2023 Statistics"
    end

    it "renders links to the next and previous year" do
      get path
      assert_select "a.cursor-pointer", text: "< 2022"
      assert_select "a.cursor-pointer", text: "2024 >"
    end

    it_behaves_like "a statistics page"

    context "when year param is not a valid year" do
      it "returns a 404" do
        get user_statistic_path("bogus", user_id: user.username)
        expect(response.status).to eq 404
      end
    end

    context "when year param is alltime" do
      it "renders the alltime stats page" do
        get user_statistic_path("alltime", user_id: user.username)
        assert_select "div.text-2xl", text: "TestUser's Alltime Statistics"
      end
    end
  end
end
