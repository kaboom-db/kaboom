require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get root_path
      expect(response).to be_successful
    end

    it "renders a form in a dialog to import a comic" do
      get root_path
      assert_select "dialog[id='importComic']" do
        assert_select "form[action='#{import_comics_path}']"
      end
    end
  end

  describe "GET /sitemap" do
    it "renders a successful response" do
      get sitemap_path
      expect(response).to be_successful
    end

    it "renders a link to the privacy policy" do
      get sitemap_path
      expect(response.body).to include(privacy_policy_url)
    end

    it "only renders urls for comics that are not nsfw" do
      comic = FactoryBot.create(:comic, nsfw: false)
      issue = FactoryBot.create(:issue, comic:)
      comic2 = FactoryBot.create(:comic, nsfw: true)
      issue2 = FactoryBot.create(:issue, comic: comic2)
      get sitemap_path

      expect(response.body).to include(comic_url(comic))
      expect(response.body).to include(comic_issue_url(issue, comic_id: comic))

      expect(response.body).not_to include(comic_url(comic2))
      expect(response.body).not_to include(comic_issue_url(issue2, comic_id: comic2))
    end

    it "only renders urls for users that are not private and confirmed" do
      user = FactoryBot.create(:user, :confirmed, private: false)
      user2 = FactoryBot.create(:user, :confirmed, private: true)
      user3 = FactoryBot.create(:user, confirmed_at: nil, private: false)
      user4 = FactoryBot.create(:user, confirmed_at: nil, private: true)

      get sitemap_path

      expect(response.body).to include(user_url(user))
      expect(response.body).to include(history_user_url(user))
      expect(response.body).to include(deck_user_url(user))
      expect(response.body).to include(favourites_user_url(user))
      expect(response.body).to include(completed_user_url(user))
      expect(response.body).to include(collection_user_url(user))
      expect(response.body).to include(wishlist_user_url(user))

      expect(response.body).not_to include(user_url(user2))
      expect(response.body).not_to include(history_user_url(user2))
      expect(response.body).not_to include(deck_user_url(user2))
      expect(response.body).not_to include(favourites_user_url(user2))
      expect(response.body).not_to include(completed_user_url(user2))
      expect(response.body).not_to include(collection_user_url(user2))
      expect(response.body).not_to include(wishlist_user_url(user2))

      expect(response.body).not_to include(user_url(user3))
      expect(response.body).not_to include(history_user_url(user3))
      expect(response.body).not_to include(deck_user_url(user3))
      expect(response.body).not_to include(favourites_user_url(user3))
      expect(response.body).not_to include(completed_user_url(user3))
      expect(response.body).not_to include(collection_user_url(user3))
      expect(response.body).not_to include(wishlist_user_url(user3))

      expect(response.body).not_to include(user_url(user4))
      expect(response.body).not_to include(history_user_url(user4))
      expect(response.body).not_to include(deck_user_url(user4))
      expect(response.body).not_to include(favourites_user_url(user4))
      expect(response.body).not_to include(completed_user_url(user4))
      expect(response.body).not_to include(collection_user_url(user4))
      expect(response.body).not_to include(wishlist_user_url(user4))
    end
  end
end
