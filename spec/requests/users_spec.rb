require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /show" do
    let(:user) { FactoryBot.create(:user, username: "Obi1", confirmed_at:) }

    context "when user is not confirmed" do
      let(:confirmed_at) { nil }

      it "renders 404" do
        expect { get user_path(user) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is confirmed" do
      let(:confirmed_at) { Time.current }

      it "renders a successful response" do
        get user_path(user)
        expect(response).to be_successful
      end

      it "displays the username" do
        get user_path(user)
        assert_select "a", text: "Obi1"
      end

      it "renders links for each section" do
        # History
        h_comic = FactoryBot.create(:comic, name: "History Comic")
        h_issue = FactoryBot.create(:issue, name: "History Issue", comic: h_comic)
        FactoryBot.create(:read_issue, issue: h_issue, user:)
        # Deck
        d_comic = FactoryBot.create(:comic, name: "Deck Comic")
        d_issue = FactoryBot.create(:issue, name: "Deck Issue 1", comic: d_comic)
        FactoryBot.create(:issue, name: "Deck Issue 2", comic: d_comic)
        FactoryBot.create(:read_issue, issue: d_issue, user:)
        # Favourites
        f_comic = FactoryBot.create(:comic, name: "Favourite Comic")
        FactoryBot.create(:favourite_item, favouritable: f_comic, user:)
        # Completed
        c_comic = FactoryBot.create(:comic, name: "Completed Comic")
        c_issue1 = FactoryBot.create(:issue, name: "Completed Issue 1", comic: c_comic)
        c_issue2 = FactoryBot.create(:issue, name: "Completed Issue 2", comic: c_comic)
        FactoryBot.create(:read_issue, issue: c_issue1, user:)
        FactoryBot.create(:read_issue, issue: c_issue2, user:)
        # Collection
        coll_issue = FactoryBot.create(:issue, name: "Collected Issue")
        FactoryBot.create(:collected_issue, issue: coll_issue, user:)
        # Wishlist
        w_comic = FactoryBot.create(:comic, name: "Wishlist Comic")
        FactoryBot.create(:wishlist_item, wishlistable: w_comic, user:)

        get user_path(user)

        assert_select "a", href: comic_issue_path(h_issue, comic_id: h_comic)
        assert_select "a", href: comic_path(d_comic)
        assert_select "a", href: comic_path(f_comic)
        assert_select "a", href: comic_path(c_comic)
        assert_select "a", href: comic_issue_path(coll_issue, comic_id: coll_issue.comic)
        assert_select "a", href: comic_path(w_comic)
      end
    end
  end

  describe "GET /history" do
    let(:user) { FactoryBot.create(:user, username: "Obi2", email: "obi2@obi.com", confirmed_at: Time.current) }

    context "when user is viewing their own history" do
      before do
        read_at = Time.new(2024, 1, 1, 0, 0, 0, "+00:00")
        FactoryBot.create(:read_issue, read_at:, user:)
        sign_in user
      end

      it "renders the history component" do
        get history_user_path(user)
        assert_select "div[data-controller='history-item']"
      end
    end

    context "when user is viewing someone else's history" do
      before do
        FactoryBot.create(:read_issue, user:)
        sign_in FactoryBot.create(:user, :confirmed)
      end

      it "renders the resource component" do
        get history_user_path(user)
        assert_select "div[data-controller='read']"
      end
    end
  end
end
