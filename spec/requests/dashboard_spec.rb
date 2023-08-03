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

      it "renders a chart for the last 30 days" do
        get dashboard_path
        assert_select "div[data-controller='history-chart']"
        assert_select "canvas[data-history-chart-target='canvas']"
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
end
