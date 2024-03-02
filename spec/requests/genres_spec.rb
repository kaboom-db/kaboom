require "rails_helper"

RSpec.describe "Genres", type: :request do
  describe "GET /show" do
    let(:genre) { FactoryBot.create(:genre, name: "Action") }

    it "renders the top 5 trending comics for the genre" do
      FactoryBot.create(:comic)
      FactoryBot.create(:comic)
      FactoryBot.create(:comic)
      FactoryBot.create(:comic)
      FactoryBot.create(:comic)
      FactoryBot.create(:comic)
      allow(Comic).to receive(:trending_for).and_return(Comic.all)
      get genre_path(genre)
      assert_select "a.text-white", count: 5
    end

    it "renders the comics for the genre" do
      FactoryBot.create(:comic, name: "Test 1", start_year: 2024, genres: [genre])
      FactoryBot.create(:comic, name: "Test 2", start_year: 2024, genres: [genre])
      get genre_path(genre)
      assert_select "b", text: "Test 1 (2024)"
      assert_select "b", text: "Test 2 (2024)"
    end
  end
end
