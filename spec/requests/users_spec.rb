require "rails_helper"

RSpec.describe "Users", type: :request do
  shared_examples_for "a private user" do
    context "when user is private" do
      let(:private) { true }

      context "when user is current user" do
        before do
          sign_in user
        end

        it "does not display a private account" do
          get path
          assert_select "p", text: "This user is private.", count: 0
        end
      end

      context "when user is not current user" do
        it "displays a private account page" do
          get path
          assert_select "p", text: "This user is private."
        end
      end
    end
  end

  describe "GET /show" do
    let(:user) { FactoryBot.create(:user, username: "Obi1", confirmed_at:, private:) }
    let(:private) { false }
    let(:path) { user_path(user) }

    context "when user is not confirmed" do
      let(:confirmed_at) { nil }

      it "renders 404" do
        expect { get path }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is confirmed" do
      let(:confirmed_at) { Time.current }

      it "renders a successful response" do
        get path
        expect(response).to be_successful
      end

      it "displays the username" do
        get path
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

        get path

        assert_select "a", href: comic_issue_path(h_issue, comic_id: h_comic)
        assert_select "a", href: comic_path(d_comic)
        assert_select "a", href: comic_path(f_comic)
        assert_select "a", href: comic_path(c_comic)
        assert_select "a", href: comic_issue_path(coll_issue, comic_id: coll_issue.comic)
        assert_select "a", href: comic_path(w_comic)
      end

      it_behaves_like "a private user"
    end
  end

  describe "GET /edit" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com") }

    context "when user is current user" do
      before do
        sign_in user
      end

      it "renders a successful response" do
        get edit_user_path(user)
        expect(response).to be_successful
      end

      it "renders an edit form" do
        get edit_user_path(user)
        assert_select "textarea[name='user[bio]']"
        assert_select "input[name='user[private]']"
        assert_select "input[name='user[show_nsfw]']"
        assert_select "input[name='user[allow_email_notifications]']"
      end
    end

    context "when user is not the current user" do
      it "redirects and sets a flash alert" do
        get edit_user_path(user)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq "You are not authorised to access this page."
      end
    end
  end

  describe "PATCH /update" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com") }

    context "when user is current user" do
      before do
        sign_in user
      end

      it "updates the user" do
        patch user_path(user), params: {user: {bio: "My cool new bio", private: true, show_nsfw: true, allow_email_notifications: false}}
        user.reload
        expect(user.bio).to eq "My cool new bio"
        expect(user.private?).to eq true
        expect(user.show_nsfw?).to eq true
        expect(user.allow_email_notifications?).to eq false
      end
    end

    context "when user is not the current user" do
      it "redirects and sets a flash alert" do
        patch user_path(user)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq "You are not authorised to access this page."
      end
    end
  end

  describe "GET /history" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com", private:) }
    let(:private) { false }
    let(:path) { history_user_path(user) }

    context "when user is viewing their own history" do
      before do
        read_at = Time.new(2024, 1, 1, 0, 0, 0, "+00:00")
        FactoryBot.create(:read_issue, read_at:, user:)
        sign_in user
      end

      it "renders the history component" do
        get path
        assert_select "div[data-controller='history-item']"
      end
    end

    context "when user is viewing someone else's history" do
      before do
        FactoryBot.create(:read_issue, user:)
        sign_in FactoryBot.create(:user, :confirmed)
      end

      it "renders the resource component" do
        get path
        assert_select "div[data-controller='read']"
      end
    end

    it_behaves_like "a private user"
  end

  describe "GET /deck" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com", private:) }
    let(:private) { false }
    let(:path) { deck_user_path(user) }

    it "renders the in progress comics for the user" do
      comic = FactoryBot.create(:comic, name: "Test 1", start_year: 2024, count_of_issues: 2)
      issue = FactoryBot.create(:issue, comic:)
      FactoryBot.create(:read_issue, issue:, user:)

      comic2 = FactoryBot.create(:comic, name: "Test 2", start_year: 2024, count_of_issues: 2)
      issue2 = FactoryBot.create(:issue, comic: comic2)
      issue3 = FactoryBot.create(:issue, comic: comic2)
      FactoryBot.create(:read_issue, issue: issue2, user:)
      FactoryBot.create(:read_issue, issue: issue3, user:)

      get path

      assert_select "b", text: "Test 1 (2024)"
      assert_select "b", text: "Test 2 (2024)", count: 0
    end

    it_behaves_like "a private user"
  end

  describe "GET /favourites" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com", private:) }
    let(:private) { false }
    let(:path) { favourites_user_path(user) }

    it "renders all the users favourites" do
      comic = FactoryBot.create(:comic, name: "Test Comic", start_year: 2024)
      issue = FactoryBot.create(:issue, name: "Test Issue", store_date: Date.new(2024, 1, 1))
      FactoryBot.create(:issue, name: "Not Fav", store_date: Date.new(2024, 1, 1))
      FactoryBot.create(:favourite_item, favouritable: comic, user:)
      FactoryBot.create(:favourite_item, favouritable: issue, user:)

      get path

      assert_select "b", text: "Test Comic (2024)"
      assert_select "b", text: "Test Issue (2024)"
      assert_select "b", text: "Not Fav (2024)", count: 0
    end

    it_behaves_like "a private user"
  end

  describe "GET /completed" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com", private:) }
    let(:private) { false }
    let(:path) { completed_user_path(user) }

    it "renders the completed comics for the user" do
      comic = FactoryBot.create(:comic, name: "Test 1", start_year: 2024, count_of_issues: 2)
      issue = FactoryBot.create(:issue, comic:)
      FactoryBot.create(:read_issue, issue:, user:)

      comic2 = FactoryBot.create(:comic, name: "Test 2", start_year: 2024, count_of_issues: 2)
      issue2 = FactoryBot.create(:issue, comic: comic2)
      issue3 = FactoryBot.create(:issue, comic: comic2)
      FactoryBot.create(:read_issue, issue: issue2, user:)
      FactoryBot.create(:read_issue, issue: issue3, user:)

      get path

      assert_select "b", text: "Test 1 (2024)", count: 0
      assert_select "b", text: "Test 2 (2024)"
    end

    it_behaves_like "a private user"
  end

  describe "GET /collection" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com", private:) }
    let(:private) { false }
    let(:path) { collection_user_path(user) }

    it "renders the collection for the user" do
      issue = FactoryBot.create(:issue)
      FactoryBot.create(:collected_issue, issue:, user:)

      get path

      assert_select "a[href='#{comic_issue_path(issue, comic_id: issue.comic)}']"
    end

    it_behaves_like "a private user"
  end

  describe "GET /wishlist" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com", private:) }
    let(:private) { false }
    let(:path) { wishlist_user_path(user) }

    it "renders the users wishlist" do
      issue = FactoryBot.create(:issue)
      FactoryBot.create(:wishlist_item, wishlistable: issue, user:)

      comic = FactoryBot.create(:comic)
      FactoryBot.create(:wishlist_item, wishlistable: comic, user:)

      get path

      assert_select "a[href='#{comic_issue_path(issue, comic_id: issue.comic)}']"
      assert_select "a[href='#{comic_path(comic)}']"
    end

    it_behaves_like "a private user"
  end

  describe "POST /follow" do
    let(:user) { FactoryBot.create(:user, :confirmed) }
    let(:current_user) { FactoryBot.create(:user, :confirmed) }

    context "when user not logged in" do
      it "redirects to the sign in page" do
        post follow_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when the follow succeeds" do
      before { sign_in current_user }

      it "creates a follow" do
        post follow_user_path(user)
        follow = Follow.last
        expect(follow.target).to eq user
        expect(follow.follower).to eq current_user
      end

      it "redirects to the user path" do
        post follow_user_path(user)
        expect(response).to redirect_to user_path(user)
      end
    end

    context "when the follow does not succeed" do
      let(:current_user) { user }

      before { sign_in current_user }

      it "does not create a follow" do
        post follow_user_path(user)
        expect(Follow.count).to eq 0
      end

      it "sets a flash message and redirects to the user page" do
        post follow_user_path(user)
        expect(response).to redirect_to user_path(user)
        expect(flash[:alert]).to eq "Could not follow #{user}."
      end
    end
  end

  describe "POST /unfollow" do
    let(:user) { FactoryBot.create(:user, :confirmed) }
    let(:current_user) { FactoryBot.create(:user, :confirmed) }

    context "when user not logged in" do
      it "redirects to the sign in page" do
        post unfollow_user_path(user)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when unfollow succeeds" do
      before do
        sign_in current_user
        FactoryBot.create(:follow, target: user, follower: current_user)
      end

      it "removes the follow" do
        post unfollow_user_path(user)
        expect(Follow.count).to eq 0
      end

      it "redirects to the user page" do
        post unfollow_user_path(user)
        expect(response).to redirect_to user_path(user)
      end
    end

    context "when unfollow does not succeed" do
      let(:current_user) { user }

      before { sign_in current_user }

      it "sets a flash message and redirects to the user page" do
        post unfollow_user_path(user)
        expect(response).to redirect_to user_path(user)
        expect(flash[:alert]).to eq "Could not unfollow #{user}."
      end
    end
  end
end
