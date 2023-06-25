require "rails_helper"

RSpec.describe "/issues", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      comic = FactoryBot.create(:comic)
      get comic_issues_path(comic)
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comic = FactoryBot.create(:comic)
      issue = FactoryBot.create(:issue, comic:)
      get comic_issue_path(issue, comic_id: comic.id)
      expect(response).to be_successful
    end
  end
end
