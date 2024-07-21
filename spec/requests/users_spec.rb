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

  shared_examples_for "follow dialogs" do
    context "when the user has followers" do
      before do
        FactoryBot.create(:follow, target: user, follower: FactoryBot.create(:user, username: "IFollow"))
      end

      it "renders the followers dialog and the followers" do
        get path
        assert_select "dialog[data-dialog-toggler-id-value='followersBtn']"
        assert_select "p", text: "IFollow"
      end
    end

    context "when the user does not have followers" do
      it "does not render the followers dialog" do
        Follow.destroy_all
        get path
        assert_select "dialog[data-dialog-toggler-id-value='followersBtn']", count: 0
      end
    end

    context "when the user follows another" do
      before do
        FactoryBot.create(:follow, follower: user, target: FactoryBot.create(:user, username: "ITarget"))
      end

      it "renders the following dialog" do
        get path
        assert_select "dialog[data-dialog-toggler-id-value='followingBtn']"
        assert_select "p", text: "ITarget"
      end
    end

    context "when the user does not have followings" do
      it "does not render the following dialog" do
        Follow.destroy_all
        get path
        assert_select "dialog[data-dialog-toggler-id-value='followingBtn']", count: 0
      end
    end
  end

  describe "GET /show" do
    let(:user) { FactoryBot.create(:user, username: "Obi1", confirmed_at:, private:) }
    let(:private) { false }
    let(:path) { user_path(user) }

    before do
      target = FactoryBot.create(:user, username: "TestUser")
      FactoryBot.create(:follow, target:, follower: user)
      FactoryBot.create(:read_issue, user: target)
    end

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

      it_behaves_like "follow dialogs"

      it "renders the user activity" do
        get path
        assert_select "#activities"
        expect(response.body).not_to include("TestUser read Issue") # Assert that we are showing the users activity, not all activities
        expect(response.body).to include("Obi1 started following TestUser")
      end
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
        assert_select "select[name='user[currency_id]']"
      end

      context "when user has hidden comics" do
        it "renders the hidden comics" do
          hc = FactoryBot.create(:hidden_comic, user:)
          get edit_user_path(user)
          assert_select "h2", text: "Hidden Comics:"
          assert_select "p", text: hc.comic.name
        end
      end

      context "when user does not have hidden comics" do
        it "does not render the hidden comic header" do
          get edit_user_path(user)
          assert_select "h2", text: "Hidden Comics:", count: 0
        end
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
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com", currency: nil) }

    context "when user is current user" do
      before do
        sign_in user
      end

      it "updates the user" do
        currency = FactoryBot.create(:currency)
        patch user_path(user), params: {user: {bio: "My cool new bio", private: true, show_nsfw: true, allow_email_notifications: false, currency_id: currency.id}}
        user.reload
        expect(user.bio).to eq "My cool new bio"
        expect(user.private?).to eq true
        expect(user.show_nsfw?).to eq true
        expect(user.allow_email_notifications?).to eq false
        expect(user.currency).to eq currency
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
        assert_select "div[data-controller='remove-item']"
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

    it_behaves_like "follow dialogs"
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

    it_behaves_like "follow dialogs"
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

    it_behaves_like "follow dialogs"
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

    it_behaves_like "follow dialogs"
  end

  describe "GET /collection" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Obi2", email: "obi2@obi.com", private:) }
    let(:private) { false }
    let(:path) { collection_user_path(user) }

    it "renders the collection for the user" do
      comic = FactoryBot.create(:comic, name: "Demon Slayer")
      issue = FactoryBot.create(:issue, comic:)
      FactoryBot.create(:collected_issue, issue:, user:)

      get path

      assert_select "p", text: "Demon Slayer"
    end

    it_behaves_like "a private user"

    it_behaves_like "follow dialogs"
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

    it_behaves_like "follow dialogs"
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

  describe "GET /load_more_activities" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Anakin") }

    context "when format is html" do
      it "renders 404" do
        get load_more_activities_user_path(user)
        expect(response.status).to eq 404
      end
    end

    context "when format is turbo_stream" do
      before do
        stub_const("Social::Feed::PER_PAGE", 1)
      end

      context "when the number of activities is less than the per page specified by Feed" do
        it "renders the turbo stream to update the activities list and to remove the load more link" do
          get load_more_activities_user_path(user, format: "turbo_stream")
          assert_select "turbo-stream[action='append'][target='activities']"
          assert_select "turbo-stream[action='remove'][target='load_more_link']"
        end
      end

      context "when the number of activities is greater than or equal to the per page specified" do
        before do
          target = FactoryBot.create(:user, username: "Obi-Wan")
          FactoryBot.create(:follow, target:, follower: user) # Create follow activity
        end

        it "renders the turbo stream to update the activities list and the load more link" do
          get load_more_activities_user_path(user, format: "turbo_stream")
          assert_select "turbo-stream[action='append'][target='activities']"
          assert_select "p", text: "Anakin started following Obi-Wan"
          assert_select "turbo-stream[action='update'][target='load_more_link']"
          assert_select "a[href='#{load_more_activities_user_path(user, page: 2)}']"
        end
      end
    end
  end

  describe "GET /load_more_followers" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Anakin") }

    context "when format is html" do
      it "renders 404" do
        get load_more_followers_user_path(user)
        expect(response.status).to eq 404
      end
    end

    context "when format is turbo_stream" do
      before do
        stub_const("UsersController::FOLLOWS_PER_PAGE", 1)
      end

      context "when the number of followers is less than the per page specified" do
        it "renders the turbo stream to update the follows list and to remove the load more link" do
          get load_more_followers_user_path(user, format: "turbo_stream")
          assert_select "turbo-stream[action='append'][target='followers']"
          assert_select "turbo-stream[action='remove'][target='follows_load_more_link']"
        end
      end

      context "when the number of followers is greater than or equal to the per page specified" do
        before do
          follower = FactoryBot.create(:user, username: "Obi-Wan")
          FactoryBot.create(:follow, target: user, follower:)
        end

        it "renders the turbo stream to update the followers list and the load more link" do
          get load_more_followers_user_path(user, format: "turbo_stream")
          assert_select "turbo-stream[action='append'][target='followers']"
          assert_select "turbo-stream[action='update'][target='follows_load_more_link']"
          assert_select "a[href='#{load_more_followers_user_path(user, page: 2)}']"
        end
      end
    end
  end

  describe "GET /load_more_following" do
    let(:user) { FactoryBot.create(:user, :confirmed, username: "Anakin") }

    context "when format is html" do
      it "renders 404" do
        get load_more_following_user_path(user)
        expect(response.status).to eq 404
      end
    end

    context "when format is turbo_stream" do
      before do
        stub_const("UsersController::FOLLOWS_PER_PAGE", 1)
      end

      context "when the number of following is less than the per page specified" do
        it "renders the turbo stream to update the following list and to remove the load more link" do
          get load_more_following_user_path(user, format: "turbo_stream")
          assert_select "turbo-stream[action='append'][target='following']"
          assert_select "turbo-stream[action='remove'][target='follows_load_more_link']"
        end
      end

      context "when the number of following is greater than or equal to the per page specified" do
        before do
          target = FactoryBot.create(:user, username: "Obi-Wan")
          FactoryBot.create(:follow, target:, follower: user)
        end

        it "renders the turbo stream to update the following list and the load more link" do
          get load_more_following_user_path(user, format: "turbo_stream")
          assert_select "turbo-stream[action='append'][target='following']"
          assert_select "turbo-stream[action='update'][target='follows_load_more_link']"
          assert_select "a[href='#{load_more_following_user_path(user, page: 2)}']"
        end
      end
    end
  end
end
