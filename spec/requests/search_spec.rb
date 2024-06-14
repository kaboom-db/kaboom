require "rails_helper"

RSpec.describe "Search", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get search_index_path
      expect(response).to be_successful
    end

    context "when a search param is present" do
      it "prefill the search input with the query" do
        get search_index_path(search: "This is my query")
        assert_select "input[value='This is my query']"
      end
    end

    context "when there are comic search results" do
      it "renders the comics header" do
        FactoryBot.create(:comic, name: "Test")
        get search_index_path(search: "Test")
        assert_select "h2", text: "Comics:"
      end
    end

    context "when there are no comic search results" do
      it "does not render the comics header" do
        FactoryBot.create(:comic, name: "No Name")
        get search_index_path(search: "Test")
        assert_select "h2", text: "Comics:", count: 0
      end
    end

    context "when there are user search results" do
      it "renders the users header" do
        FactoryBot.create(:user, username: "Test")
        get search_index_path(search: "Test")
        assert_select "h2", text: "Users:"
      end
    end

    context "when there are no user search results" do
      it "does not render the users header" do
        FactoryBot.create(:user, username: "None")
        get search_index_path(search: "Test")
        assert_select "h2", text: "Users:", count: 0
      end
    end
  end
end
