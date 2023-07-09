require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  describe "GET /index" do
    context "when user is not logged in" do
      it "redirects to the log in page" do
        get dashboard_index_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      before do
        sign_in FactoryBot.create(:user, :confirmed)
      end

      it "renders a successfull response" do
        get dashboard_index_path
        expect(response).to be_successful
      end
    end
  end
end
