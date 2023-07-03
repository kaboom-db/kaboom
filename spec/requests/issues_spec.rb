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

    context "when user is logged in" do
      it "adds a visit to the issue" do
        issue = FactoryBot.create(:issue)
        get comic_issue_path(issue, comic_id: issue.comic.id)
        visit = Visit.last
        expect(visit.user).to be_nil
        expect(visit.visited).to eq issue
      end
    end

    context "when user is not logged in" do
      it "adds a visit to the issue" do
        user = FactoryBot.create(:user, :confirmed)
        sign_in user
        issue = FactoryBot.create(:issue)
        get comic_issue_path(issue, comic_id: issue.comic.id)
        visit = Visit.last
        expect(visit.user).to eq user
        expect(visit.visited).to eq issue
      end
    end
  end
end
