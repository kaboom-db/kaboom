require "rails_helper"

RSpec.describe "Registrations", type: :request do
  let(:user) { FactoryBot.create(:user, :confirmed) }

  describe "GET /users/edit" do
    context "when user is not signed in" do
      it "redirects to the sign in page" do
        get "/users/edit"
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "redirects to the user page" do
        get "/users/edit"
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  describe "PUT /users" do
    context "when user is not signed in" do
      it "redirects to the sign in page" do
        put "/users"
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "redirects to the user page" do
        put "/users"
        expect(response).to redirect_to user_path(user)
      end
    end
  end

  describe "POST /user" do
    let(:params) {
      {
        user: {
          username: "test",
          email: "test@example.com",
          password: "secret123",
          password_confirmation: "secret123"
        },
        bot_protection:
      }
    }

    context "when bot protection param is not present" do
      let(:bot_protection) { nil }

      it "redirects the user back to the sign up page" do
        post "/users", params: params.delete(:bot_protection)
        expect(response).to redirect_to "/users/sign_up"
      end

      it "sets a flash message" do
        post "/users", params: params.delete(:bot_protection)
        expect(flash[:alert]).to eq "Bot protection failed."
      end
    end

    context "when bot protection is valid" do
      let(:bot_protection) { "MoObAk" }

      it "redirects the user the root path" do
        post "/users", params: params
        expect(response).to redirect_to root_path
      end

      it "creates a user" do
        post "/users", params: params
        user = User.last
        expect(user.username).to eq "test"
        expect(user.email).to eq "test@example.com"
      end
    end

    context "when bot protection is invalid" do
      let(:bot_protection) { "bogus" }

      it "redirects the user back to the sign up page" do
        post "/users", params: params
        expect(response).to redirect_to "/users/sign_up"
      end

      it "sets a flash message" do
        post "/users", params: params
        expect(flash[:alert]).to eq "Bot protection failed."
      end
    end
  end
end
