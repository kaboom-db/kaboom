require "rails_helper"

RSpec.describe "CollectedIssues", type: :request do
  describe "PATCH /collected_issues/:id" do
    let(:user) { FactoryBot.create(:user, :confirmed) }
    let(:collected_issue) { FactoryBot.create(:collected_issue, user: user, collected_on: Date.new(2024, 1, 1), price_paid: 2) }

    context "when user is not signed in" do
      it "redirects to the sign in page" do
        patch collected_issue_path(collected_issue)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is signed in" do
      context "when current user has permission to update the collected issue" do
        before do
          sign_in user
        end

        it "updates the collected issue and redirects" do
          patch collected_issue_path(collected_issue), params: {collected_issue: {price_paid: 1, collected_on: "2024-01-02"}}
          expect(collected_issue.reload.collected_on).to eq Date.new(2024, 1, 2)
          expect(collected_issue.price_paid).to eq 1
          expect(response).to redirect_to dashboard_collection_path
        end

        context "when a param is invalid" do
          it "does not update the collected issue" do
            patch collected_issue_path(collected_issue), params: {collected_issue: {price_paid: 1, collected_on: nil}}
            expect(collected_issue.reload.collected_on).to eq Date.new(2024, 1, 1)
            expect(collected_issue.price_paid).to eq 2
          end
        end
      end

      context "when current user does not have permission to update the collected issue" do
        before do
          sign_in FactoryBot.create(:user, :confirmed)
        end

        it "throws an error (404)" do
          expect {
            patch collected_issue_path(collected_issue), params: {collected_issue: {price_paid: 1, collected_on: "2024-01-02"}}
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
