require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "GET /index" do
    context "when user is not logged in" do
      it "redirects to the log in page" do
        get dashboard_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before do
        target = FactoryBot.create(:user, username: "TestUser")
        FactoryBot.create(:follow, target:, follower: user)
        FactoryBot.create(:read_issue, user: target)
        sign_in user
      end

      it "renders a successfull response" do
        get dashboard_path
        expect(response).to be_successful
      end

      it "renders the amount of issues read" do
        FactoryBot.create(:read_issue, user:)
        FactoryBot.create(:read_issue, user:)
        get dashboard_path
        assert_select "p.text-4xl", text: "2"
      end

      it "renders the amount of issues collected" do
        FactoryBot.create(:collected_issue, user:)
        FactoryBot.create(:collected_issue, user:)
        FactoryBot.create(:collected_issue, user:)
        get dashboard_path
        assert_select "p.text-4xl", text: "3"
      end

      it "renders a chart for the last 14 days" do
        get dashboard_path
        assert_select "div[data-controller='chart']"
        assert_select "canvas[data-chart-target='canvas']"
      end

      it "renders the comics progress sidebar" do
        get dashboard_path
        assert_select "#comic_progress"
      end

      it "renders the feed" do
        get dashboard_path
        assert_select "#activities"
        expect(response.body).to include("TestUser read Issue")
        expect(response.body).not_to include("started following TestUser") # Assert that we are showing the users feed, not all activities
      end
    end
  end

  describe "GET /history" do
    context "when user is not logged in" do
      it "redirects to the log in page" do
        get dashboard_history_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before do
        sign_in user
      end

      it "renders a successfull response" do
        get dashboard_history_path
        expect(response).to be_successful
      end

      context "when there is no issue specified" do
        let(:issue_1) { FactoryBot.create(:issue, name: "Issue 1") }
        let(:issue_2) { FactoryBot.create(:issue, name: "Issue 2") }

        before do
          @day_1 = 1.day.ago
          @day_2 = 2.days.ago
          FactoryBot.create(:read_issue, user:, issue: issue_1, read_at: @day_1)
          FactoryBot.create(:read_issue, user:, issue: issue_2, read_at: @day_2)
        end

        it "shows the day sections" do
          get dashboard_history_path
          assert_select "p.text-2xl", text: @day_1.strftime("%-d %b %Y")
          assert_select "p.text-2xl", text: @day_2.strftime("%-d %b %Y")
        end

        it "renders all the issues" do
          get dashboard_history_path
          assert_select "p.font-bold", text: issue_1.name
          assert_select "p.font-bold", text: issue_2.name
        end
      end

      context "when there is an issue specified" do
        let(:issue_1) { FactoryBot.create(:issue, name: "Issue 1") }
        let(:issue_2) { FactoryBot.create(:issue, name: "Issue 2") }

        before do
          @day_1 = 1.day.ago
          @day_2 = 2.days.ago
          FactoryBot.create(:read_issue, user:, issue: issue_1, read_at: @day_1)
          FactoryBot.create(:read_issue, user:, issue: issue_2, read_at: @day_2)
        end

        it "only shows days when that issue was read" do
          get dashboard_history_path(issue: issue_1.id)
          assert_select "p.text-2xl", text: @day_1.strftime("%-d %b %Y")
          assert_select "p.text-2xl", text: @day_2.strftime("%-d %b %Y"), count: 0
        end

        it "renders only the history for that issues" do
          get dashboard_history_path(issue: issue_1.id)
          assert_select "p.font-bold", text: issue_1.name
          assert_select "p.font-bold", text: issue_2.name, count: 0
        end
      end
    end
  end

  describe "GET /load_more_activities" do
    context "when user is not logged in" do
      it "redirects to the log in page" do
        get dashboard_load_more_activities_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is signed in" do
      let(:user) { FactoryBot.create(:user, :confirmed, username: "Bob") }

      before do
        sign_in user
      end

      context "when format is html" do
        it "renders 404" do
          get dashboard_load_more_activities_path
          expect(response.status).to eq 404
        end
      end

      context "when format is turbo_stream" do
        before do
          stub_const("Social::Feed::PER_PAGE", 1)
        end

        context "when the number of activities is less than the per page specified by Feed" do
          it "renders the turbo stream to update the activities list and to remove the load more link" do
            get dashboard_load_more_activities_path(format: "turbo_stream")
            assert_select "turbo-stream[action='append'][target='activities']"
            assert_select "turbo-stream[action='remove'][target='load_more_link']"
          end
        end

        context "when the number of activities is greater than or equal to the per page specified" do
          before do
            target = FactoryBot.create(:user, username: "Obi")
            FactoryBot.create(:follow, target:, follower: user)
            comic = FactoryBot.create(:comic, name: "Amazing Comic")
            issue = FactoryBot.create(:issue, issue_number: "1", name: "Amazing Issue", comic:)
            FactoryBot.create(:read_issue, user: target, issue:) # Create read activity
          end

          it "renders the turbo stream to update the activities list and the load more link" do
            get dashboard_load_more_activities_path(format: "turbo_stream")
            assert_select "turbo-stream[action='append'][target='activities']"
            assert_select "p", text: "Obi read Issue #1 of Amazing Comic (Amazing Issue)"
            assert_select "turbo-stream[action='update'][target='load_more_link']"
            assert_select "a[href='#{dashboard_load_more_activities_path(page: 2)}']"
          end
        end
      end
    end
  end
end
