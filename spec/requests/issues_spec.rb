require "rails_helper"

RSpec.describe "/issues", type: :request do
  include ActiveSupport::Testing::TimeHelpers

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

    context "when user is not logged in" do
      it "adds a visit to the issue" do
        issue = FactoryBot.create(:issue)
        get comic_issue_path(issue, comic_id: issue.comic.id)
        visit = Visit.last
        expect(visit.user).to be_nil
        expect(visit.visited).to eq issue
      end
    end

    context "when user is logged in" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before do
        sign_in user

        @issue = FactoryBot.create(:issue)
        get comic_issue_path(@issue, comic_id: @issue.comic.id)
      end

      it "adds a visit to the issue" do
        visit = Visit.last
        expect(visit.user).to eq user
        expect(visit.visited).to eq @issue
      end

      context "when user visited page less than 5 mins ago" do
        it "only adds one visit" do
          get comic_issue_path(@issue, comic_id: @issue.comic.id) # Visiting the issue page again
          expect(@issue.visits.count).to eq 1
        end
      end
    end
  end

  describe "POST /read" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(xhr)
    end

    context "when the user is not logged in" do
      let(:xhr) { false }

      it "redirects to the sign in page" do
        post read_comic_issue_path("1", comic_id: comic.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      let(:xhr) { false }

      before do
        sign_in user
      end

      context "when issue does not exist" do
        before do
          post read_comic_issue_path("1", comic_id: comic.id)
        end

        it "redirects to the comic path" do
          expect(response).to redirect_to comic_path(comic)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not find that issue."
        end
      end

      context "when read_at is invalid" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          post read_comic_issue_path(@issue, comic_id: comic.id, read_at: "not a datetime")
        end

        it "redirects to the issue page" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not mark that issue as read."
        end
      end

      context "when read_at is valid" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          post read_comic_issue_path(@issue, comic_id: comic.id, read_at: "2023-07-07 18:47:56")
        end

        it "redirects to the issue page" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully marked this issue as read."
        end

        it "creates a read issue" do
          read_issue = user.read_issues.last
          expect(read_issue.issue).to eq @issue
          expect(read_issue.user).to eq user
          expect(read_issue.read_at).to eq DateTime.new(2023, 7, 7, 18, 47, 56)
        end
      end

      context "when read_at is not specified" do
        before do
          freeze_time
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          post read_comic_issue_path(@issue, comic_id: comic.id)
        end

        it "redirects to the issue page" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully marked this issue as read."
        end

        it "creates a read issue with read_at the current time" do
          read_issue = user.read_issues.last
          expect(read_issue.issue).to eq @issue
          expect(read_issue.user).to eq user
          expect(read_issue.read_at).to eq Time.current
        end
      end
    end

    context "when request is an Ajax request" do
      let(:xhr) { true }

      before do
        sign_in user
      end

      context "when issue does not exist" do
        before do
          post read_comic_issue_path("1", comic_id: comic.id)
        end

        it "it returns json with a message and success status" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq false
          expect(body["has_read"]).to eq false
          expect(body["read_count"]).to eq 0
          expect(body["issue"]).to be_nil
          expect(body["message"]).to eq "Could not find that issue."
        end
      end

      context "when read_at is invalid" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
          FactoryBot.create(:read_issue, issue: @issue, user:) if prev_read
          post read_comic_issue_path(@issue, comic_id: comic.id, read_at: "not a datetime")
        end

        context "when user has previously read the issue" do
          let(:prev_read) { true }

          it "sets has_read to true" do
            body = JSON.parse(response.body)
            expect(body["success"]).to eq false
            expect(body["has_read"]).to eq true
            expect(body["read_count"]).to eq 1
            expect(body["issue"]).to eq @issue.id
            expect(body["message"]).to eq "Could not mark Test Comic - Issue 1 as read."
          end
        end

        context "when user has not previously read the issue" do
          let(:prev_read) { false }

          it "sets has_read to false" do
            body = JSON.parse(response.body)
            expect(body["success"]).to eq false
            expect(body["has_read"]).to eq false
            expect(body["read_count"]).to eq 0
            expect(body["issue"]).to eq @issue.id
            expect(body["message"]).to eq "Could not mark Test Comic - Issue 1 as read."
          end
        end
      end

      context "when read_at is valid" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
          post read_comic_issue_path(@issue, comic_id: comic.id, read_at: "2023-07-07 18:47:56")
        end

        it "returns json wuth a message and success status" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["has_read"]).to eq true
          expect(body["read_count"]).to eq 1
          expect(body["issue"]).to eq @issue.id
          expect(body["message"]).to eq "You read Test Comic - Issue 1."
        end

        it "creates a read issue" do
          read_issue = user.read_issues.last
          expect(read_issue.issue).to eq @issue
          expect(read_issue.user).to eq user
          expect(read_issue.read_at).to eq DateTime.new(2023, 7, 7, 18, 47, 56)
        end
      end

      context "when read_at is not specified" do
        before do
          freeze_time
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
          post read_comic_issue_path(@issue, comic_id: comic.id)
        end

        it "returns json wuth a message and success status" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["has_read"]).to eq true
          expect(body["read_count"]).to eq 1
          expect(body["issue"]).to eq @issue.id
          expect(body["message"]).to eq "You read Test Comic - Issue 1."
        end

        it "creates a read issue with read_at the current time" do
          read_issue = user.read_issues.last
          expect(read_issue.issue).to eq @issue
          expect(read_issue.user).to eq user
          expect(read_issue.read_at).to eq Time.current
        end
      end
    end
  end
end
