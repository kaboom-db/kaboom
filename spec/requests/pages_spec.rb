require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get root_path
      expect(response).to be_successful
    end
  end

  describe "GET /dashboard" do
    context "when user is not logged in" do
      it "redirects to the log in page" do
        get dashboard_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      before do
        sign_in User.create!(email: "test@a.com", password: "123456")
      end

      it "renders a successfull response" do
        get dashboard_path
        expect(response).to be_successful
      end
    end
  end
end
