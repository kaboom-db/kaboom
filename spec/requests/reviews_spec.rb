require "rails_helper"

RSpec.describe "Reviews", type: :request do
  def assert_review(readonly:)
    assert_select "h1", text: "Review"
    assert_select "form" do
      readonly_tag = readonly ? "[readonly='readonly']" : ":not([readonly])"
      assert_select "input[name='review[title]']#{readonly_tag}"
      assert_select "input[name='review[reviewable_type]'][type='hidden']"
      assert_select "input[name='review[reviewable_id]'][type='hidden']"
      assert_select "textarea[name='review[content]']#{readonly_tag}"
    end
  end

  shared_examples_for "an unauthorized request" do
    it "redirects to the sign in page" do
      send(method, path)
      expect(response).to redirect_to new_user_session_path
    end
  end

  shared_examples_for "a not found request" do
    it "renders a 404" do
      send(method, path)
      expect(response.status).to eq 404
    end
  end

  describe "GET /reviews/:id" do
    let(:review) { FactoryBot.create(:review) }

    it "renders a successful response" do
      get review_path(review)
      expect(response).to be_successful
    end

    it "renders the review" do
      get review_path(review)
      assert_review(readonly: true)
    end
  end

  describe "GET /reviews/:id/edit" do
    let(:review) { FactoryBot.create(:review, user: review_user) }
    let(:review_user) { FactoryBot.create(:user, :confirmed) }

    context "when user is not signed in" do
      it_behaves_like "an unauthorized request" do
        let(:path) { edit_review_path(review) }
        let(:method) { :get }
      end
    end

    context "when the user is not allowed to edit the review" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before do
        sign_in user
      end

      it_behaves_like "a not found request" do
        let(:path) { edit_review_path(review) }
        let(:method) { :get }
      end
    end

    context "when the user can edit the review" do
      before do
        sign_in review_user
      end

      it "renders a successful response" do
        get edit_review_path(review)
        expect(response).to be_successful
      end

      it "renders the form" do
        get edit_review_path(review)
        assert_review(readonly: false)
      end
    end
  end

  describe "GET /reviews/new" do
    context "when user is not signed in" do
      it_behaves_like "an unauthorized request" do
        let(:path) { new_review_path }
        let(:method) { :get }
      end
    end

    context "when reviewable_type is not valid" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before { sign_in user }

      it "redirects back with a flash message" do
        get new_review_path # No reviewable type specified
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq "Invalid reviewable_type"
      end
    end

    context "when the reviewable could not be found" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before { sign_in user }

      it "redirects back with a flash message" do
        get new_review_path(reviewable_type: "Comic", reviewable_id: 10000)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq "Could not find resource to review"
      end
    end

    context "when user already has a review for the resource" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:resource) { FactoryBot.create(:comic) }

      before do
        sign_in user
        @review = FactoryBot.create(:review, user:, reviewable: resource, title: "This is a review")
      end

      it "renders a review form for that resource" do
        get new_review_path(reviewable_type: "Comic", reviewable_id: resource.id)
        assert_select "form[action='#{review_path(@review)}']"
        assert_review(readonly: false)
      end
    end

    context "when the user does not have a review for the resource" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:resource) { FactoryBot.create(:comic) }

      before { sign_in user }

      it "renders a form for the review" do
        get new_review_path(reviewable_type: "Comic", reviewable_id: resource.id)
        assert_select "form[action='#{reviews_path}']"
        assert_review(readonly: false)
      end
    end
  end

  describe "POST /reviews" do
    context "when user is not signed in" do
      it_behaves_like "an unauthorized request" do
        let(:path) { reviews_path }
        let(:method) { :post }
      end
    end

    context "when reviewable_type is not valid" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before { sign_in user }

      it "redirects back with a flash message" do
        post reviews_path # No reviewable type specified
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq "Invalid reviewable_type"
      end
    end

    context "when the reviewable could not be found" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before { sign_in user }

      it "redirects back with a flash message" do
        post reviews_path, params: {review: {reviewable_type: "Comic", reviewable_id: 1000}}
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq "Could not find resource to review"
      end
    end

    context "with valid params" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:resource) { FactoryBot.create(:comic) }

      before { sign_in user }

      def perform
        post reviews_path, params: {review: {reviewable_type: "Comic", reviewable_id: resource.id, title: "New review", content: "This is a review"}}
      end

      it "creates a review for the specified reviewable and user" do
        perform
        review = Review.first
        expect(review.reviewable).to eq resource
        expect(review.user).to eq user
        expect(review.title).to eq "New review"
        expect(review.content).to eq "This is a review"
      end

      it "redirects to the review path with a flash message" do
        perform
        expect(response).to redirect_to review_path(Review.first)
        expect(flash[:notice]).to eq "Review submitted."
      end
    end

    context "with invalid params" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:resource) { FactoryBot.create(:comic) }

      before { sign_in user }

      def perform
        post reviews_path, params: {review: {reviewable_type: "Comic", reviewable_id: resource.id, title: nil, content: nil}}
      end

      it "renders the form with errors" do
        perform
        assert_review(readonly: false)
        assert_select "li", text: "Title can't be blank"
        assert_select "li", text: "Content can't be blank"
      end

      it "does not create a review" do
        perform
        expect(Review.count).to eq 0
      end
    end
  end

  describe "PATCH /reviews/:id" do
    context "when user is not signed in" do
      let(:review) { FactoryBot.create(:review) }

      it_behaves_like "an unauthorized request" do
        let(:path) { review_path(review) }
        let(:method) { :patch }
      end
    end

    context "when the user is not allowed to update the review" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:review) { FactoryBot.create(:review) }

      before do
        sign_in user
      end

      it_behaves_like "a not found request" do
        let(:path) { review_path(review) }
        let(:method) { :patch }
      end
    end

    context "with valid params" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:review) { FactoryBot.create(:review, user:, title: "TITLE", content: "CONTENT", reviewable: resource) }
      let(:resource) { FactoryBot.create(:comic) }
      let(:other_resource) { FactoryBot.create(:comic) }

      before do
        sign_in user
      end

      def perform
        patch review_path(review), params: {review: {reviewable_type: "Comic", reviewable_id: other_resource.id, title: "Updated", content: "Updated content"}}
      end

      it "updates the review" do
        perform
        expect(review.reload.title).to eq "Updated"
        expect(review.content).to eq "Updated content"
      end

      it "redirects to the review path with a flash message" do
        perform
        expect(response).to redirect_to review_path(review)
        expect(flash[:notice]).to eq "Review updated."
      end

      it "does not update the reviewable" do
        perform
        expect(review.reload.reviewable).to eq resource
      end
    end

    context "with invalid params" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:review) { FactoryBot.create(:review, user:, title: "TITLE", content: "CONTENT", reviewable: resource) }
      let(:resource) { FactoryBot.create(:comic) }

      before do
        sign_in user
      end

      def perform
        patch review_path(review), params: {review: {title: nil, content: nil}}
      end

      it "does not update the review" do
        perform
        expect(review.reload.title).to eq "TITLE"
        expect(review.content).to eq "CONTENT"
      end

      it "renders the form" do
        perform
        assert_review(readonly: false)
        assert_select "form[action='#{review_path(review)}']"
      end
    end
  end

  describe "DELETE /reviews/:id" do
    context "when user is not signed in" do
      let(:review) { FactoryBot.create(:review) }

      it_behaves_like "an unauthorized request" do
        let(:path) { review_path(review) }
        let(:method) { :delete }
      end
    end

    context "when the user is not allowed to delete the review" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:review) { FactoryBot.create(:review) }

      before do
        sign_in user
      end

      it_behaves_like "a not found request" do
        let(:path) { review_path(review) }
        let(:method) { :delete }
      end
    end

    context "when resource is a comic" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:review) { FactoryBot.create(:review, user:, reviewable: resource) }
      let(:resource) { FactoryBot.create(:comic) }

      before do
        sign_in user
      end

      def perform
        delete review_path(review)
      end

      it "destroys the review" do
        perform
        expect(Review.count).to eq 0
      end

      it "redirects to the comic path" do
        perform
        expect(response).to redirect_to comic_path(resource)
        expect(flash[:notice]).to eq "Review has been deleted."
      end
    end

    context "when resource is an issue" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:review) { FactoryBot.create(:review, user:, reviewable: resource) }
      let(:resource) { FactoryBot.create(:issue) }

      before do
        sign_in user
      end

      def perform
        delete review_path(review)
      end

      it "destroys the review" do
        perform
        expect(Review.count).to eq 0
      end

      it "redirects to the comic path" do
        perform
        expect(response).to redirect_to comic_issue_path(resource, comic_id: resource.comic)
        expect(flash[:notice]).to eq "Review has been deleted."
      end
    end
  end
end
