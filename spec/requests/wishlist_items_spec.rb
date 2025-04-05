require "rails_helper"

RSpec.describe "WishlistItems", type: :request do
  describe "POST /wishlist_items/:id/move" do
    let(:wishlist_item) { FactoryBot.create(:wishlist_item, user: current_user, position: 1) }
    let(:current_user) { FactoryBot.create(:user, :confirmed) }
    let(:position) { 2 }

    def perform
      post move_wishlist_item_path(wishlist_item), params: {position:}
    end

    context "when user is not logged in" do
      it "renders unauthorized" do
        perform
        expect(response).to have_http_status(:unauthorized)
        expect(wishlist_item.reload.position).to eq(1)
      end
    end

    context "when the current user is not the owner of the wishlist item" do
      before do
        sign_in FactoryBot.create(:user, :confirmed)
      end

      it "renders unauthorized" do
        perform
        expect(response).to have_http_status(:unauthorized)
        expect(wishlist_item.reload.position).to eq(1)
      end
    end

    context "when the current user is the owner of the wishlist item" do
      before do
        sign_in current_user
      end

      context "when the position is valid" do
        it "moves the wishlist item to the specified position" do
          perform
          expect(response).to have_http_status(:ok)
          expect(wishlist_item.reload.position).to eq(2)
        end
      end

      context "when the position is invalid" do
        let(:position) { nil }

        it "renders bad request" do
          perform
          expect(response).to have_http_status(:bad_request)
          expect(wishlist_item.reload.position).to eq(1)
        end
      end
    end
  end
end
