require "rails_helper"

RSpec.describe "/comics", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      FactoryBot.create(:comic)
      get comics_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comic = FactoryBot.create(:comic)
      get comic_url(comic)
      expect(response).to be_successful
    end
  end
end
