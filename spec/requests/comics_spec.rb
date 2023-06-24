require "rails_helper"

RSpec.describe "/comics", type: :request do
  describe "GET /index" do
    before do
      FactoryBot.create(:comic, name: "Test Comic")
      FactoryBot.create(:comic, aliases: "Comic\nTesting", name: "Cool Comic")
      FactoryBot.create(:comic, aliases: "Comic", name: "No Name")
    end

    it "renders a successful response" do
      FactoryBot.create(:comic)
      get comics_path
      expect(response).to be_successful
    end

    context "when there is no search query" do
      it "does not show any search results" do
        get comics_path(search: "")
        assert_select "p.text-sm.font-bold", text: "Results for :", count: 0
        assert_select "#search" do
          assert_select "small", text: "Test Comic", count: 0
          assert_select "small", text: "Cool Comic", count: 0
          assert_select "small", text: "No Name", count: 0
        end
      end
    end

    context "when there is a search query" do
      it "shows the search results" do
        get comics_path(search: "test")
        assert_select "p.text-sm.font-bold", text: "Results for test:"
        assert_select "#search" do
          assert_select "small", text: "Test Comic"
          assert_select "small", text: "Cool Comic"
          assert_select "small", text: "No Name", count: 0
        end
      end
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comic = FactoryBot.create(:comic)
      get comic_path(comic)
      expect(response).to be_successful
    end
  end
end
