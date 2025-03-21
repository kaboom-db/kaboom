require "rails_helper"
require_relative "shared_examples/reviews"
require_relative "shared_examples/ratings"

RSpec.describe "/issues", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  describe "GET /index" do
    it "redirects to the comic path" do
      comic = FactoryBot.create(:comic)
      get comic_issues_path(comic)
      expect(response).to redirect_to comic_path(comic)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comic = FactoryBot.create(:comic)
      issue = FactoryBot.create(:issue, comic:)
      get comic_issue_path(issue, comic_id: comic.id)
      expect(response).to be_successful
    end

    context "when request is made a bot" do
      it "does not add a visit to the comic" do
        issue = FactoryBot.create(:issue)
        get comic_issue_path(issue, comic_id: issue.comic.id), headers: {"User-Agent" => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"}
        expect(VisitBucket.count).to eq 0
      end
    end

    context "when user is not logged in" do
      it "adds a visit to the issue" do
        issue = FactoryBot.create(:issue)
        get comic_issue_path(issue, comic_id: issue.comic.id)
        expect(VisitBucket.count).to eq 1
        day = VisitBucket.find_by(period: VisitBucket::DAY)
        expect(day.user).to be_nil
        expect(day.visited).to eq issue
        expect(day.period_start).to eq DateTime.current.beginning_of_day.to_i
        expect(day.period_end).to eq DateTime.current.end_of_day.to_i
        expect(day.count).to eq 1

        # month = VisitBucket.find_by(period: VisitBucket::MONTH)
        # expect(month.user).to be_nil
        # expect(month.visited).to eq issue
        # expect(month.period_start).to eq DateTime.current.beginning_of_month.to_i
        # expect(month.period_end).to eq DateTime.current.end_of_month.to_i
        # expect(month.count).to eq 1

        # year = VisitBucket.find_by(period: VisitBucket::YEAR)
        # expect(year.user).to be_nil
        # expect(year.visited).to eq issue
        # expect(year.period_start).to eq DateTime.current.beginning_of_year.to_i
        # expect(year.period_end).to eq DateTime.current.end_of_year.to_i
        # expect(year.count).to eq 1
      end
    end

    context "when user is logged in" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before do
        sign_in user

        @issue = FactoryBot.create(:issue)
      end

      def perform
        get comic_issue_path(@issue, comic_id: @issue.comic.id)
      end

      it "adds a visit to the issue" do
        perform
        day = VisitBucket.find_by(period: VisitBucket::DAY)
        expect(day.user).to eq user
        expect(day.visited).to eq @issue
        expect(day.period_start).to eq DateTime.current.beginning_of_day.to_i
        expect(day.period_end).to eq DateTime.current.end_of_day.to_i
        expect(day.count).to eq 1

        # month = VisitBucket.find_by(period: VisitBucket::MONTH)
        # expect(month.user).to eq user
        # expect(month.visited).to eq @issue
        # expect(month.period_start).to eq DateTime.current.beginning_of_month.to_i
        # expect(month.period_end).to eq DateTime.current.end_of_month.to_i
        # expect(month.count).to eq 1

        # year = VisitBucket.find_by(period: VisitBucket::YEAR)
        # expect(year.user).to eq user
        # expect(year.visited).to eq @issue
        # expect(year.period_start).to eq DateTime.current.beginning_of_year.to_i
        # expect(year.period_end).to eq DateTime.current.end_of_year.to_i
        # expect(year.count).to eq 1
      end

      context "when user visited page less than 5 mins ago" do
        it "only adds one visit" do
          perform
          get comic_issue_path(@issue, comic_id: @issue.comic.id) # Visiting the issue page again
          expect(@issue.visit_buckets.count).to eq 1
          day = @issue.visit_buckets.find_by(period: VisitBucket::DAY)
          expect(day.user).to eq user
          expect(day.visited).to eq @issue
          expect(day.period_start).to eq DateTime.current.beginning_of_day.to_i
          expect(day.period_end).to eq DateTime.current.end_of_day.to_i
          expect(day.count).to eq 1

          # month = @issue.visit_buckets.find_by(period: VisitBucket::MONTH)
          # expect(month.user).to eq user
          # expect(month.visited).to eq @issue
          # expect(month.period_start).to eq DateTime.current.beginning_of_month.to_i
          # expect(month.period_end).to eq DateTime.current.end_of_month.to_i
          # expect(month.count).to eq 1

          # year = @issue.visit_buckets.find_by(period: VisitBucket::YEAR)
          # expect(year.user).to eq user
          # expect(year.visited).to eq @issue
          # expect(year.period_start).to eq DateTime.current.beginning_of_year.to_i
          # expect(year.period_end).to eq DateTime.current.end_of_year.to_i
          # expect(year.count).to eq 1
        end
      end

      context "when user has already visited the issue" do
        it "appends to the existing buckets" do
          day = FactoryBot.create(
            :visit_bucket,
            period: VisitBucket::DAY,
            period_start: DateTime.current.beginning_of_day.to_i,
            period_end: DateTime.current.end_of_day.to_i,
            visited: @issue,
            count: 1,
            updated_at: 301.seconds.ago,
            user:
          )
          # month = FactoryBot.create(
          #   :visit_bucket,
          #   period: VisitBucket::MONTH,
          #   period_start: DateTime.current.beginning_of_month.to_i,
          #   period_end: DateTime.current.end_of_month.to_i,
          #   visited: @issue,
          #   count: 1,
          #   updated_at: 301.seconds.ago,
          #   user:
          # )
          # year = FactoryBot.create(
          #   :visit_bucket,
          #   period: VisitBucket::YEAR,
          #   period_start: DateTime.current.beginning_of_year.to_i,
          #   period_end: DateTime.current.end_of_year.to_i,
          #   visited: @issue,
          #   count: 1,
          #   updated_at: 301.seconds.ago,
          #   user:
          # )
          perform
          expect(VisitBucket.count).to eq 1
          expect(day.reload.count).to eq 2
          # expect(month.reload.count).to eq 2
          # expect(year.reload.count).to eq 2
        end
      end

      context "when user has notifications for that issue" do
        before do
          travel_to DateTime.new(2024, 2, 2, 10)

          @notification1 = FactoryBot.create(:notification, user:, notifiable: @issue, read_at: nil)
          # Notification that has already been read
          @notification2 = FactoryBot.create(:notification, user:, notifiable: @issue, read_at: DateTime.new(2024, 1, 1, 10))
          # Notification that is not for the logged in user
          @notification3 = FactoryBot.create(:notification, user: FactoryBot.create(:user), notifiable: @issue, read_at: nil)
          # Notification for a different issue
          @notification4 = FactoryBot.create(:notification, user:, notifiable: FactoryBot.create(:issue), read_at: nil)
        end

        it "marks the relevant notifications read at to the current time" do
          perform
          expect(@notification1.reload.read_at).to eq DateTime.new(2024, 2, 2, 10)
          expect(@notification2.reload.read_at).to eq DateTime.new(2024, 1, 1, 10)
          expect(@notification3.reload.read_at).to eq nil
          expect(@notification4.reload.read_at).to eq nil
        end
      end
    end
  end

  describe "GET /edit" do
    context "when the user is signed in" do
      before do
        sign_in FactoryBot.create(:user, :confirmed)
      end

      it "renders a form to edit the comic" do
        comic = FactoryBot.create(:comic)
        issue = FactoryBot.create(:issue, comic:)
        get edit_comic_issue_path(issue, comic_id: comic)
        assert_select "input[name='issue[rating]']"
        assert_select "input[name='issue[page_count]']"
        assert_select "input[name='issue[isbn]']"
        assert_select "input[name='issue[upc]']"
      end
    end

    context "when the user is not signed in" do
      it "redirects to the sign in page" do
        comic = FactoryBot.create(:comic)
        issue = FactoryBot.create(:issue, comic:)
        get edit_comic_issue_path(issue, comic_id: comic)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /update" do
    context "when user is signed in" do
      let(:valid_params) {
        {
          rating: "Teens",
          page_count: 127,
          isbn: "978-1-56619-909-4",
          upc: "0987654321"
        }
      }
      let(:invalid_params) { {isbn: "I'm not an isbn"} }
      let(:comic) { FactoryBot.create(:comic, name: "test comic") }
      let(:issue) { FactoryBot.create(:issue, comic:, name: "test issue") }

      before do
        sign_in FactoryBot.create(:user, :confirmed)
      end

      context "with valid params" do
        before do
          patch comic_issue_path(issue, comic_id: comic, params: {issue: valid_params})
        end

        it "sets a flash message and redirects to the issue" do
          expect(flash[:notice]).to eq "test issue was successfully updated."
          expect(response).to redirect_to comic_issue_path(issue, comic_id: comic)
        end

        it "updates the comic" do
          expect(issue.reload.rating).to eq "Teens"
          expect(issue.page_count).to eq 127
          expect(issue.isbn).to eq "978-1-56619-909-4"
          expect(issue.upc).to eq "0987654321"
        end
      end

      context "with invalid params" do
        before do
          patch comic_issue_path(issue, comic_id: comic, params: {issue: invalid_params})
        end

        it "renders the edit form" do
          assert_select "input[name='issue[rating]']"
          assert_select "input[name='issue[page_count]']"
          assert_select "input[name='issue[isbn]']"
          assert_select "input[name='issue[upc]']"
        end
      end
    end

    context "when the user is not signed in" do
      it "redirects to the sign in page" do
        comic = FactoryBot.create(:comic)
        issue = FactoryBot.create(:issue, comic:)
        patch comic_issue_path(issue, comic_id: comic)
        expect(response).to redirect_to new_user_session_path
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

  describe "POST /unread" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(xhr)
    end

    context "when the user is not logged in" do
      let(:xhr) { false }

      it "redirects to the sign in page" do
        post unread_comic_issue_path("1", comic_id: comic.id)
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
          post unread_comic_issue_path("1", comic_id: comic.id), params: {read_id: 123}
        end

        it "redirects to the comic path" do
          expect(response).to redirect_to comic_path(comic)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not find that issue."
        end
      end

      context "when the ReadIssue could not be found" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          post unread_comic_issue_path(@issue, comic_id: comic.id), params: {read_id: 123}
        end

        it "redirects to the issue path" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "You have not read this issue."
        end
      end

      context "when user is authorised to unread this issue" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          @read_issue = FactoryBot.create(:read_issue, issue: @issue, user:)
          post unread_comic_issue_path(@issue, comic_id: comic.id), params: {read_id: @read_issue.id}
        end

        it "redirects to the issue path" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully unmarked this issue."
        end

        it "destroys the read issue" do
          expect(user.read_issues.count).to eq 0
        end
      end
    end

    context "when request is an Ajax request" do
      let(:xhr) { true }

      before do
        sign_in user
      end

      context "when user is authorised to unread this issue" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
          @read_issue = FactoryBot.create(:read_issue, issue: @issue, user:)
          post unread_comic_issue_path(@issue, comic_id: comic.id), params: {read_id: @read_issue.id}
        end

        it "responds with json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["has_read"]).to eq false
          expect(body["read_count"]).to eq 0
          expect(body["issue"]).to eq @issue.id
          expect(body["message"]).to eq "You unread Test Comic - Issue 1."
        end

        it "destroys the read issue" do
          expect(user.read_issues.count).to eq 0
        end
      end
    end
  end

  describe "POST /collect" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(xhr)
    end

    context "when the user is not logged in" do
      let(:xhr) { false }

      it "redirects to the sign in page" do
        post collect_comic_issue_path("1", comic_id: comic.id)
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
          post collect_comic_issue_path("1", comic_id: comic.id)
        end

        it "redirects to the comic path" do
          expect(response).to redirect_to comic_path(comic)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not find that issue."
        end
      end

      context "when user previously collected" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          FactoryBot.create(:collected_issue, issue: @issue, user:)
          post collect_comic_issue_path(@issue, comic_id: comic.id, collected_on: "not a datetime")
        end

        it "redirects to the issue page" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not collect this issue."
        end
      end

      context "when collected_on and price_paid are valid" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          post collect_comic_issue_path(@issue, comic_id: comic.id, collected_on: "2023-07-07 18:47:56", price_paid: 7.99)
        end

        it "redirects to the issue page" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully collected this issue."
        end

        it "creates a collect issue" do
          collected_issue = user.collected_issues.last
          expect(collected_issue.issue).to eq @issue
          expect(collected_issue.user).to eq user
          expect(collected_issue.collected_on).to eq Date.new(2023, 7, 7)
          expect(collected_issue.price_paid).to eq 7.99
        end
      end

      context "when collected_on and price_paid are not specified" do
        before do
          freeze_time
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          post collect_comic_issue_path(@issue, comic_id: comic.id)
        end

        it "redirects to the issue page" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully collected this issue."
        end

        it "creates a collect issue with collected_on the current time" do
          collected_issue = user.collected_issues.last
          expect(collected_issue.issue).to eq @issue
          expect(collected_issue.user).to eq user
          expect(collected_issue.collected_on).to eq Date.today
          expect(collected_issue.price_paid).to eq 0
        end
      end
    end

    context "when request is an Ajax request" do
      let(:xhr) { true }

      before do
        sign_in user
      end

      context "user previously collected" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
          FactoryBot.create(:collected_issue, issue: @issue, user:)
          post collect_comic_issue_path(@issue, comic_id: comic.id, collected_on: "not a datetime")
        end

        it "returns valid json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq false
          expect(body["has_collected"]).to eq true
          expect(body["issue"]).to eq @issue.id
          expect(body["message"]).to eq "Could not collect Test Comic - Issue 1."
        end
      end

      context "when collected_on and price_paid are valid" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
          post collect_comic_issue_path(@issue, comic_id: comic.id, collected_on: "2023-07-07", price_paid: 7.99)
        end

        it "returns json wuth a message and success status" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["has_collected"]).to eq true
          expect(body["issue"]).to eq @issue.id
          expect(body["message"]).to eq "You collected Test Comic - Issue 1."
        end

        it "creates a collect issue" do
          collected_issue = user.collected_issues.last
          expect(collected_issue.issue).to eq @issue
          expect(collected_issue.user).to eq user
          expect(collected_issue.collected_on).to eq Date.new(2023, 7, 7)
          expect(collected_issue.price_paid).to eq 7.99
        end
      end

      context "when collected_on and price_paid are not specified" do
        before do
          freeze_time
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
          post collect_comic_issue_path(@issue, comic_id: comic.id)
        end

        it "returns json wuth a message and success status" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["has_collected"]).to eq true
          expect(body["issue"]).to eq @issue.id
          expect(body["message"]).to eq "You collected Test Comic - Issue 1."
        end

        it "creates a collect issue with collected_on the current time with 0 price_paid" do
          collected_issue = user.collected_issues.last
          expect(collected_issue.issue).to eq @issue
          expect(collected_issue.user).to eq user
          expect(collected_issue.collected_on).to eq Date.today
          expect(collected_issue.price_paid).to eq 0
        end
      end
    end
  end

  describe "POST /uncollect" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(xhr)
    end

    context "when the user is not logged in" do
      let(:xhr) { false }

      it "redirects to the sign in page" do
        post uncollect_comic_issue_path("1", comic_id: comic.id)
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
          post uncollect_comic_issue_path("1", comic_id: comic.id)
        end

        it "redirects to the comic path" do
          expect(response).to redirect_to comic_path(comic)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not find that issue."
        end
      end

      context "when the issue is not collected" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          post uncollect_comic_issue_path(@issue, comic_id: comic.id)
        end

        it "redirects to the issue path" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "You have not collected this issue."
        end
      end

      context "when user is authorised to uncollect this issue" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1)
          @collected = FactoryBot.create(:collected_issue, issue: @issue, user:)
          post uncollect_comic_issue_path(@issue, comic_id: comic.id)
        end

        it "redirects to the issue path" do
          expect(response).to redirect_to comic_issue_path(@issue, comic_id: comic.id)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully uncollected this issue."
        end

        it "destroys the collected item" do
          expect(user.collected_issues.count).to eq 0
        end
      end
    end

    context "when request is an Ajax request" do
      let(:xhr) { true }

      before do
        sign_in user
      end

      context "when user is authorised to uncollect this issue" do
        before do
          @issue = FactoryBot.create(:issue, comic:, issue_number: 1, name: "Issue 1")
          @collected = FactoryBot.create(:collected_issue, issue: @issue, user:)
          post uncollect_comic_issue_path(@issue, comic_id: comic.id)
        end

        it "responds with json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["has_collected"]).to eq false
          expect(body["issue"]).to eq @issue.id
          expect(body["message"]).to eq "You uncollected Test Comic - Issue 1."
        end

        it "destroys the collected item" do
          expect(user.collected_issues.count).to eq 0
        end
      end
    end
  end

  describe "wishlisting" do
    it_behaves_like "a wishlistable resource", :issue
  end

  describe "favouriting" do
    it_behaves_like "a favouritable resource", :issue
  end

  describe "POST /refresh" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        issue = FactoryBot.create(:issue)
        post refresh_comic_issue_path(issue, comic_id: issue.comic)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      before do
        sign_in FactoryBot.create(:user, :confirmed)
        @issue = FactoryBot.create(:issue)
      end

      it "starts a background refresh of the comic" do
        expect(ImportWorker).to receive(:perform_async).with("Issue", @issue.cv_id)
        post refresh_comic_issue_path(@issue, comic_id: @issue.comic)
        expect(response).to redirect_to comic_issue_path(@issue, comic_id: @issue.comic)
      end
    end
  end

  describe "GET /comics/:comic_id/issues/:id/reviews" do
    it_behaves_like "a reviewable resource" do
      let(:resource) { FactoryBot.create(:issue) }
      let(:reviews_path) { reviews_comic_issue_path(resource, comic_id: resource.comic) }
      let(:resource_path) { comic_issue_path(resource, comic_id: resource.comic) }
    end
  end

  describe "POST /comics/:comic_id/issues/:id/rate" do
    it_behaves_like "a rateable resource" do
      let(:resource) { FactoryBot.create(:issue) }
      let(:rate_path) { rate_comic_issue_path(resource, comic_id: resource.comic) }
    end
  end
end
