require "rails_helper"

RSpec.describe "/comics", type: :request do
  describe "GET /index" do
    before do
      FactoryBot.create(:comic, name: "Test Comic")
      FactoryBot.create(:comic, aliases: "Comic\nTesting", name: "Cool Comic")
      FactoryBot.create(:comic, aliases: "Comic", name: "No Name")
    end

    it "renders a successful response" do
      FactoryBot.create(:comic)
      get comics_path
      expect(response).to be_successful
    end

    context "when there is no search query" do
      it "does not show any search results" do
        get comics_path(search: "")
        assert_select "p.text-sm.font-bold", text: "Results for :", count: 0
        assert_select "#search" do
          assert_select "small", text: "Test Comic", count: 0
          assert_select "small", text: "Cool Comic", count: 0
          assert_select "small", text: "No Name", count: 0
        end
      end
    end

    context "when there is a search query" do
      it "shows the search results" do
        get comics_path(search: "test")
        assert_select "p.text-sm.font-bold", text: "Results for test:"
        assert_select "#search" do
          assert_select "small", text: "Test Comic"
          assert_select "small", text: "Cool Comic"
          assert_select "small", text: "No Name", count: 0
        end
      end
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comic = FactoryBot.create(:comic)
      get comic_path(comic)
      expect(response).to be_successful
    end

    context "when user is not logged in" do
      it "adds a visit to the comic" do
        comic = FactoryBot.create(:comic)
        get comic_path(comic)
        visit = Visit.last
        expect(visit.user).to be_nil
        expect(visit.visited).to eq comic
      end
    end

    context "when user is logged in" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before do
        sign_in user

        @comic = FactoryBot.create(:comic)
        get comic_path(@comic)
      end

      it "adds a visit to the comic" do
        visit = Visit.last
        expect(visit.user).to eq user
        expect(visit.visited).to eq @comic
      end

      context "when user visited page less than 5 mins ago" do
        it "only adds one visit" do
          get comic_path(@comic) # Visiting the comic page again
          expect(@comic.visits.count).to eq 1
        end
      end
    end
  end

  describe "POST /import" do
    context "when user is not logged in" do
      it "redirects to the log in page" do
        post import_comics_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      let(:body) {
        {
          error: "OK",
          results: {
            aliases: "Some Alias",
            api_detail_url: "https://comicvine.gamespot.com/api/volume/4050-63559/",
            count_of_issues: 5,
            date_last_updated: "2023-03-31 14:58:51",
            deck: "Some Deck",
            description: "<p>Published by the German wing of Panini Comics.</p>",
            id: "12345",
            image: {
              medium_url: "https://comicvine.gamespot.com/a/uploads/scale_medium/11/119711/3109464-ultimatecomicsspiderman1_831.jpg"
            },
            name: "Ultimate Comics: Spider-Man",
            publisher: {
              name: "Panini Verlag"
            },
            site_detail_url: "https://comicvine.gamespot.com/ultimate-comics-spider-man/4050-63559/",
            start_year: "2012"
          }
        }.to_json
      }
      let(:results) {
        [
          {
            aliases: nil,
            api_detail_url: "https://comicvine.gamespot.com/api/issue/4000-129176/",
            cover_date: "1997-12-29",
            date_last_updated: "2022-05-31 19:47:55",
            deck: nil,
            description: "A really long description",
            id: 123,
            image: {
              medium_url: "https://comicvine.gamespot.com/a/uploads/scale_medium/11136/111369808/6786544-one%20piece%201.jpg"
            },
            issue_number: "1",
            name: "Romance Dawn: Bōken no Yoake",
            site_detail_url: "https://comicvine.gamespot.com/one-piece-1-romance-dawn-boken-no-yoake/4000-129176/",
            store_date: "1997-12-24"
          },
          {
            aliases: nil,
            api_detail_url: "https://comicvine.gamespot.com/api/issue/4000-129185/",
            cover_date: "1998-04-08",
            date_last_updated: "2023-04-21 18:56:34",
            deck: nil,
            description: "AN EVEN LONGER DESCRIPTION",
            id: 456,
            image: {
              medium_url: "https://comicvine.gamespot.com/a/uploads/scale_medium/11136/111369808/6786545-one%20piece%202.jpg"
            },
            issue_number: "2 + 1",
            name: "Versus!! Buggy Kaizoku-Dan",
            site_detail_url: "https://comicvine.gamespot.com/one-piece-2-versus-buggy-kaizoku-dan/4000-129185/",
            store_date: "1998-04-03"
          }
        ]
      }

      before do
        sign_in FactoryBot.create(:user, :confirmed)
      end

      context "when ComicVine comic is found" do
        before do
          credentials = Rails.application.credentials.dig(:comic_vine)
          base_url = credentials[:url]
          api_key = credentials[:api_key]

          options = {
            field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
          }
          params = URI.encode_www_form(options.merge({api_key:, format: "json"})).to_s
          stub_request(:get, "#{base_url}volume/4050-12345/?#{params}").to_return(status: 200, body:)

          options = {
            field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume",
            filter: "volume:12345",
            offset: 0
          }
          params = URI.encode_www_form(options.merge({api_key:, format: "json"})).to_s
          stub_request(:get, "#{base_url}issues/?#{params}").to_return(status: 200, body: {results:}.to_json)
        end

        it "redirects to the imported comic" do
          post import_comics_path(params: {comicvine_id: "12345"})
          expect(response).to redirect_to comic_path(Comic.last)
        end

        it "sets a flash message" do
          post import_comics_path(params: {comicvine_id: "12345"})
          expect(flash[:notice]).to eq "Ultimate Comics: Spider-Man was successfully imported."
        end

        it "creates a comic" do
          expect { post import_comics_path(params: {comicvine_id: "12345"}) }.to change(Comic, :count).by(1)
        end

        it "imports issues for the comic" do
          post import_comics_path(params: {comicvine_id: "12345"})
          comic = Comic.last
          expect(comic.issues.count).to eq 2
        end
      end

      context "when the comic is not found on comicvine" do
        before do
          credentials = Rails.application.credentials.dig(:comic_vine)
          base_url = credentials[:url]
          api_key = credentials[:api_key]

          options = {
            field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
          }
          params = URI.encode_www_form(options.merge({api_key:, format: "json"})).to_s
          stub_request(:get, "#{base_url}volume/4050-12345/?#{params}").to_return(status: 404, body: "")

          post import_comics_path(params: {comicvine_id: "12345"})
        end

        it "redirects to the comics path" do
          expect(response).to redirect_to comics_path
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "There was an error importing this comic."
        end
      end
    end
  end

  describe "POST /wishlist" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic") }
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      allow_any_instance_of(ActionDispatch::Request).to receive(:xhr?).and_return(xhr)
    end

    context "when the user is not logged in" do
      let(:xhr) { false }

      it "redirects to the sign in page" do
        post wishlist_comic_path(comic)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      let(:xhr) { false }

      before do
        sign_in user
      end

      context "when wishlisting is unsuccessful" do
        before do
          FactoryBot.create(:wishlist_item, wishlistable: comic, user:)
          post wishlist_comic_path(comic)
        end

        it "redirects to the comic page" do
          expect(response).to redirect_to comic_path(comic)
        end

        it "sets a flash message" do
          expect(flash[:alert]).to eq "Could not wishlist this comic."
        end
      end

      context "when wishlisting is successful" do
        before do
          post wishlist_comic_path(comic)
        end

        it "redirects to the issue page" do
          expect(response).to redirect_to comic_path(comic)
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully wishlisted this comic."
        end

        it "creates a wishlisted item" do
          wishlisted = user.wishlist_items.last
          expect(wishlisted.wishlistable).to eq comic
          expect(wishlisted.user).to eq user
        end
      end
    end

    context "when request is an Ajax request" do
      let(:xhr) { true }

      before do
        sign_in user
      end

      context "when wishlisting is unsuccessful" do
        before do
          FactoryBot.create(:wishlist_item, wishlistable: comic, user:)
          post wishlist_comic_path(comic)
        end

        it "returns valid json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq false
          expect(body["wishlisted"]).to eq true
          expect(body["issue"]).to eq nil
          expect(body["message"]).to eq "Could not wishlist Test Comic."
        end
      end

      context "when wishlisting is successful" do
        before do
          post wishlist_comic_path(comic)
        end

        it "returns valid json" do
          body = JSON.parse(response.body)
          expect(body["success"]).to eq true
          expect(body["wishlisted"]).to eq true
          expect(body["issue"]).to eq nil
          expect(body["message"]).to eq "You wishlisted Test Comic."
        end

        it "creates a wishlisted item" do
          wishlisted = user.wishlist_items.last
          expect(wishlisted.wishlistable).to eq comic
          expect(wishlisted.user).to eq user
        end
      end
    end
  end
end
