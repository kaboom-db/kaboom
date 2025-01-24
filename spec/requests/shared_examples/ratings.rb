RSpec.shared_examples_for "a rateable resource" do
  let(:rating) { 4 }

  def perform
    post rate_path, params: {rating:}
  end

  context "when there is no user signed in" do
    it "redirects to the sign in page" do
      perform
      expect(response).to redirect_to new_user_session_path
    end
  end

  context "when there is a user signed in" do
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      sign_in user
    end

    context "when the user already has a rating for the resource" do
      before do
        @rating = FactoryBot.create(:rating, rateable: resource, user:, score: 10)
      end

      it "updates the rating" do
        perform
        expect(@rating.reload.score).to eq 4
      end

      it "renders json" do
        perform
        json = JSON.parse(response.body)
        expect(json).to eq({"success" => true})
      end
    end

    context "when the user does not have a rating for the resource" do
      before do
        @rating = FactoryBot.create(:rating, rateable: resource, score: 10) # Not for the current user
      end

      it "creates a rating for the resource" do
        expect { perform }.to change { Rating.count }.by 1
        expect(@rating.reload.score).to eq 10
      end

      it "renders json" do
        perform
        json = JSON.parse(response.body)
        expect(json).to eq({"success" => true})
      end
    end

    context "when the rating is invalid" do
      let(:rating) { 0 }

      it "does not update/create the rating" do
        perform
        expect(Rating.count).to eq 0
      end

      it "renders json" do
        perform
        json = JSON.parse(response.body)
        expect(json).to eq({"success" => false})
      end
    end
  end
end
