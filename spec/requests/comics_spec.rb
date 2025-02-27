require "rails_helper"
require_relative "shared_examples/reviews"
require_relative "shared_examples/ratings"

RSpec.describe "/comics", type: :request do
  include ActiveSupport::Testing::TimeHelpers

  describe "GET /index" do
    before do
      FactoryBot.create(:comic, name: "Test Comic", start_year: nil)
      FactoryBot.create(:comic, aliases: "Comic\nTesting", name: "Cool Comic", start_year: nil)
      FactoryBot.create(:comic, aliases: "Comic", name: "No Name", start_year: nil)
      FactoryBot.create(:comic, name: "NSFW Test Comic", nsfw: true, start_year: nil)
    end

    it "renders a successful response" do
      FactoryBot.create(:comic)
      get comics_path
      expect(response).to be_successful
    end

    it "renders recently updated safe for work comics" do
      nsfw = FactoryBot.create(:comic, nsfw: true)
      comic = FactoryBot.create(:comic, nsfw: false)
      get comics_path
      assert_select "a[href='#{comic_path(comic)}']", count: 1
      assert_select "a[href='#{comic_path(nsfw)}']", count: 0
    end

    it "renders recently updated safe for work issues" do
      nsfw = FactoryBot.create(:comic, nsfw: true)
      nsfw_issue = FactoryBot.create(:issue, comic: nsfw)
      issue = FactoryBot.create(:issue)
      get comics_path
      assert_select "a[href='#{comic_issue_path(issue, comic_id: issue.comic)}']", count: 1
      assert_select "a[href='#{comic_issue_path(nsfw_issue, comic_id: nsfw)}']", count: 0
    end

    it "renders links for all the genres" do
      FactoryBot.create(:genre, name: "Genre 1")
      FactoryBot.create(:genre, name: "Genre 2")
      FactoryBot.create(:genre, name: "Genre 3")
      get comics_path
      Genre.all.each do |genre|
        assert_select "a[href='#{genre_path(genre)}']"
        assert_select "p.font-bold", text: genre.name
      end
    end

    it "renders a link to global search with the search param" do
      get comics_path(search: "HEY")
      assert_select "a[href='#{search_index_path(search: "HEY")}']"
    end

    context "when there is no search query" do
      it "does not show any search results" do
        get comics_path(search: "")
        assert_select "p.text-sm.font-bold", text: "Results for :", count: 0
        assert_select "#search" do
          assert_select "b", text: "Test Comic", visible: :hidden, count: 0
          assert_select "b", text: "Cool Comic", visible: :hidden, count: 0
          assert_select "b", text: "No Name", visible: :hidden, count: 0
        end
      end
    end

    context "when there is a search query" do
      it "limits results to 6" do
        FactoryBot.create(:comic, name: "Test Comic The Sequel")
        FactoryBot.create(:comic, name: "Test Comic The Sequels' Sequel")
        FactoryBot.create(:comic, name: "Test Comic The Sequels' Sequels' Sequel")
        FactoryBot.create(:comic, name: "Test Comic The Sequels' Sequels' Sequels' Sequel")
        get comics_path(search: "comic")
        assert_select "#search" do
          assert_select "b", count: 6
        end
      end

      context "when the user has nsfw enabled" do
        before { sign_in FactoryBot.create(:user, :confirmed, show_nsfw: true) }

        it "includes nsfw results" do
          get comics_path(search: "test")
          assert_select "h2.text-2xl", text: "Results for test:"
          assert_select "#search" do
            assert_select "b", text: "Test Comic", visible: :hidden
            assert_select "b", text: "Cool Comic", visible: :hidden
            assert_select "b", text: "NSFW Test Comic", visible: :hidden
            assert_select "b", text: "No Name", visible: :hidden, count: 0
          end
        end
      end

      context "when the user does not have nsfw enabled" do
        before { sign_in FactoryBot.create(:user, :confirmed, show_nsfw: false) }

        it "does not include nsfw results" do
          get comics_path(search: "test")
          assert_select "h2.text-2xl", text: "Results for test:"
          assert_select "#search" do
            assert_select "b", text: "Test Comic", visible: :hidden
            assert_select "b", text: "Cool Comic", visible: :hidden
            assert_select "b", text: "NSFW Test Comic", visible: :hidden, count: 0
            assert_select "b", text: "No Name", visible: :hidden, count: 0
          end
        end
      end

      context "when there is no user" do
        it "does not include nsfw results" do
          get comics_path(search: "test")
          assert_select "h2.text-2xl", text: "Results for test:"
          assert_select "#search" do
            assert_select "b", text: "Test Comic", visible: :hidden
            assert_select "b", text: "Cool Comic", visible: :hidden
            assert_select "b", text: "NSFW Test Comic", visible: :hidden, count: 0
            assert_select "b", text: "No Name", visible: :hidden, count: 0
          end
        end
      end
    end

    context "when the user is logged in" do
      before do
        sign_in FactoryBot.create(:user, :confirmed)
      end

      it "renders the comics progress sidebar" do
        get comics_path
        assert_select "#comic_progress"
      end
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      comic = FactoryBot.create(:comic)
      get comic_path(comic)
      expect(response).to be_successful
    end

    it "sets the page title" do
      comic = FactoryBot.create(:comic, name: "Test", description: "Cool description", image: "image.png")
      get comic_path(comic)
      assert_select "title", text: "Test - Kaboom"
    end

    context "when request is made a bot" do
      it "does not add a visit to the comic" do
        comic = FactoryBot.create(:comic)
        get comic_path(comic), headers: {"User-Agent" => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"}
        expect(VisitBucket.count).to eq 0
      end
    end

    context "when user is not logged in" do
      it "adds a visit to the comic" do
        comic = FactoryBot.create(:comic)
        get comic_path(comic)
        expect(VisitBucket.count).to eq 1
        day = VisitBucket.find_by(period: VisitBucket::DAY)
        expect(day.user).to be_nil
        expect(day.visited).to eq comic
        expect(day.period_start).to eq DateTime.current.beginning_of_day.to_i
        expect(day.period_end).to eq DateTime.current.end_of_day.to_i
        expect(day.count).to eq 1

        # month = VisitBucket.find_by(period: VisitBucket::MONTH)
        # expect(month.user).to be_nil
        # expect(month.visited).to eq comic
        # expect(month.period_start).to eq DateTime.current.beginning_of_month.to_i
        # expect(month.period_end).to eq DateTime.current.end_of_month.to_i
        # expect(month.count).to eq 1

        # year = VisitBucket.find_by(period: VisitBucket::YEAR)
        # expect(year.user).to be_nil
        # expect(year.visited).to eq comic
        # expect(year.period_start).to eq DateTime.current.beginning_of_year.to_i
        # expect(year.period_end).to eq DateTime.current.end_of_year.to_i
        # expect(year.count).to eq 1
      end
    end

    context "when user is logged in" do
      let(:user) { FactoryBot.create(:user, :confirmed) }

      before do
        sign_in user

        @comic = FactoryBot.create(:comic)
      end

      def perform
        get comic_path(@comic)
      end

      it "adds a visit to the comic" do
        perform
        day = VisitBucket.find_by(period: VisitBucket::DAY)
        expect(day.user).to eq user
        expect(day.visited).to eq @comic
        expect(day.period_start).to eq DateTime.current.beginning_of_day.to_i
        expect(day.period_end).to eq DateTime.current.end_of_day.to_i
        expect(day.count).to eq 1

        # month = VisitBucket.find_by(period: VisitBucket::MONTH)
        # expect(month.user).to eq user
        # expect(month.visited).to eq @comic
        # expect(month.period_start).to eq DateTime.current.beginning_of_month.to_i
        # expect(month.period_end).to eq DateTime.current.end_of_month.to_i
        # expect(month.count).to eq 1

        # year = VisitBucket.find_by(period: VisitBucket::YEAR)
        # expect(year.user).to eq user
        # expect(year.visited).to eq @comic
        # expect(year.period_start).to eq DateTime.current.beginning_of_year.to_i
        # expect(year.period_end).to eq DateTime.current.end_of_year.to_i
        # expect(year.count).to eq 1
      end

      context "when user visited page less than 5 mins ago" do
        it "does not add another visit" do
          perform
          get comic_path(@comic) # Visiting the comic page again
          expect(@comic.visit_buckets.count).to eq 1
          day = @comic.visit_buckets.find_by(period: VisitBucket::DAY)
          expect(day.user).to eq user
          expect(day.visited).to eq @comic
          expect(day.period_start).to eq DateTime.current.beginning_of_day.to_i
          expect(day.period_end).to eq DateTime.current.end_of_day.to_i
          expect(day.count).to eq 1

          # month = @comic.visit_buckets.find_by(period: VisitBucket::MONTH)
          # expect(month.user).to eq user
          # expect(month.visited).to eq @comic
          # expect(month.period_start).to eq DateTime.current.beginning_of_month.to_i
          # expect(month.period_end).to eq DateTime.current.end_of_month.to_i
          # expect(month.count).to eq 1

          # year = @comic.visit_buckets.find_by(period: VisitBucket::YEAR)
          # expect(year.user).to eq user
          # expect(year.visited).to eq @comic
          # expect(year.period_start).to eq DateTime.current.beginning_of_year.to_i
          # expect(year.period_end).to eq DateTime.current.end_of_year.to_i
          # expect(year.count).to eq 1
        end
      end

      context "when user has already visited the comic" do
        it "appends to the existing buckets" do
          day = FactoryBot.create(
            :visit_bucket,
            period: VisitBucket::DAY,
            period_start: DateTime.current.beginning_of_day.to_i,
            period_end: DateTime.current.end_of_day.to_i,
            visited: @comic,
            count: 1,
            updated_at: 301.seconds.ago,
            user:
          )
          # month = FactoryBot.create(
          #   :visit_bucket,
          #   period: VisitBucket::MONTH,
          #   period_start: DateTime.current.beginning_of_month.to_i,
          #   period_end: DateTime.current.end_of_month.to_i,
          #   visited: @comic,
          #   count: 1,
          #   updated_at: 301.seconds.ago,
          #   user:
          # )
          # year = FactoryBot.create(
          #   :visit_bucket,
          #   period: VisitBucket::YEAR,
          #   period_start: DateTime.current.beginning_of_year.to_i,
          #   period_end: DateTime.current.end_of_year.to_i,
          #   visited: @comic,
          #   count: 1,
          #   updated_at: 301.seconds.ago,
          #   user:
          # )
          perform
          expect(VisitBucket.count).to eq 1
          expect(day.reload.count).to eq 2
          # expect(month.reload.count).to eq 2
          # expect(year.reload.count).to eq 2
        end
      end
    end
  end

  describe "GET /edit" do
    context "when the user is signed in" do
      before do
        sign_in FactoryBot.create(:user, :confirmed)
      end

      it "renders a form to edit the comic" do
        comic = FactoryBot.create(:comic)
        get edit_comic_path(comic)
        assert_select "select[name='comic[comic_type]']"
        assert_select "select[name='comic[genre_ids][]']"
        assert_select "input[name='comic[nsfw]']"
        assert_select "select[name='comic[country_id]']"
      end
    end

    context "when the user is not signed in" do
      it "redirects to the sign in page" do
        comic = FactoryBot.create(:comic)
        get edit_comic_path(comic)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /update" do
    context "when user is signed in" do
      let(:genre) { FactoryBot.create(:genre) }
      let(:country) { FactoryBot.create(:country) }
      let(:valid_params) {
        {
          nsfw: true,
          comic_type: Comic::ANNUAL_SERIES,
          genre_ids: [genre.id],
          country_id: country.id
        }
      }
      let(:invalid_params) { {comic_type: "bogus dawg", country_id: "bogus maloney"} }
      let(:comic) { FactoryBot.create(:comic, name: "test comic") }

      before do
        sign_in FactoryBot.create(:user, :confirmed)
      end

      context "with valid params" do
        before do
          patch comic_path(comic, params: {comic: valid_params})
        end

        it "sets a flash message and redirects to the comic" do
          expect(flash[:notice]).to eq "test comic was successfully updated."
          expect(response).to redirect_to comic_path(comic)
        end

        it "updates the comic" do
          expect(comic.reload.nsfw).to eq true
          expect(comic.comic_type).to eq Comic::ANNUAL_SERIES
          expect(comic.genres).to contain_exactly(genre)
          expect(comic.country).to eq country
        end
      end

      context "with invalid params" do
        before do
          patch comic_path(comic, params: {comic: invalid_params})
        end

        it "renders the edit form" do
          assert_select "select[name='comic[comic_type]']"
          assert_select "select[name='comic[genre_ids][]']"
          assert_select "input[name='comic[nsfw]']"
          assert_select "select[name='comic[country_id]']"
        end
      end
    end

    context "when the user is not signed in" do
      it "redirects to the sign in page" do
        comic = FactoryBot.create(:comic)
        patch comic_path(comic)
        expect(response).to redirect_to new_user_session_path
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
          expect(response).to redirect_to edit_comic_path(Comic.last)
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
          expect(comic.nsfw).to eq false
          expect(comic.issues.count).to eq 2
        end

        it "sets nsfw if present" do
          post import_comics_path(params: {comicvine_id: "12345", nsfw: true})
          comic = Comic.last
          expect(comic.nsfw).to eq true
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

  describe "wishlisting" do
    it_behaves_like "a wishlistable resource", :comic
  end

  describe "favouriting" do
    it_behaves_like "a favouritable resource", :comic
  end

  describe "POST /read_range" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        comic = FactoryBot.create(:comic)
        post read_range_comic_path(comic)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      let(:user) { FactoryBot.create(:user, :confirmed) }
      let(:xhr) { false }
      let(:max) { 10 }

      before do
        sign_in user

        @comic = FactoryBot.create(:comic, count_of_issues: max)
        @issue1 = FactoryBot.create(:issue, comic: @comic)
        @issue2 = FactoryBot.create(:issue, comic: @comic)
        @issue3 = FactoryBot.create(:issue, comic: @comic)
        @issue4 = FactoryBot.create(:issue, comic: @comic)
        @issue5 = FactoryBot.create(:issue, comic: @comic)
        @issue6 = FactoryBot.create(:issue, comic: @comic)
        @issue7 = FactoryBot.create(:issue, comic: @comic)
        @issue8 = FactoryBot.create(:issue, comic: @comic)
        @issue9 = FactoryBot.create(:issue, comic: @comic)
        @issue10 = FactoryBot.create(:issue, comic: @comic)
        post read_range_comic_path(@comic), params: {start: start_issue, end: end_issue}, xhr:
      end

      context "when `start` is less than 0" do
        let(:start_issue) { -1 }
        let(:end_issue) { 5 }

        it "marks all the issues up to `end` as read" do
          expect(user.read_issues.count).to eq 5
          read_issues = user.read_issues
          expect(read_issues[0].issue).to eq @issue1
          expect(read_issues[1].issue).to eq @issue2
          expect(read_issues[2].issue).to eq @issue3
          expect(read_issues[3].issue).to eq @issue4
          expect(read_issues[4].issue).to eq @issue5
        end
      end

      context "when `start` is greater than `end`" do
        let(:start_issue) { 10 }
        let(:end_issue) { 5 }

        it "marks all the issues up to `end` as read" do
          expect(user.read_issues.count).to eq 5
          read_issues = user.read_issues
          expect(read_issues[0].issue).to eq @issue1
          expect(read_issues[1].issue).to eq @issue2
          expect(read_issues[2].issue).to eq @issue3
          expect(read_issues[3].issue).to eq @issue4
          expect(read_issues[4].issue).to eq @issue5
        end
      end

      context "when `end` is greater than the count of issues" do
        let(:start_issue) { 5 }
        let(:end_issue) { 11 }

        it "marks all the issues from `start` as read" do
          expect(user.read_issues.count).to eq 6
          read_issues = user.read_issues
          expect(read_issues[0].issue).to eq @issue5
          expect(read_issues[1].issue).to eq @issue6
          expect(read_issues[2].issue).to eq @issue7
          expect(read_issues[3].issue).to eq @issue8
          expect(read_issues[4].issue).to eq @issue9
          expect(read_issues[5].issue).to eq @issue10
        end
      end

      context "when request is xhr" do
        let(:start_issue) { 5 }
        let(:end_issue) { 10 }
        let(:xhr) { true }

        it "marks the range as read" do
          expect(user.read_issues.count).to eq 6
          read_issues = user.read_issues
          expect(read_issues[0].issue).to eq @issue5
          expect(read_issues[1].issue).to eq @issue6
          expect(read_issues[2].issue).to eq @issue7
          expect(read_issues[3].issue).to eq @issue8
          expect(read_issues[4].issue).to eq @issue9
          expect(read_issues[5].issue).to eq @issue10
        end

        it "renders valid json" do
          json = JSON.parse(response.body)
          expect(json["message"]).to eq "Successfully marked issues 5-10 as read"
        end
      end

      context "when request is not xhr" do
        let(:start_issue) { 1 }
        let(:end_issue) { 10 }

        it "marks the range as read" do
          expect(user.read_issues.count).to eq 10
          read_issues = user.read_issues
          expect(read_issues[0].issue).to eq @issue1
          expect(read_issues[1].issue).to eq @issue2
          expect(read_issues[2].issue).to eq @issue3
          expect(read_issues[3].issue).to eq @issue4
          expect(read_issues[4].issue).to eq @issue5
          expect(read_issues[5].issue).to eq @issue6
          expect(read_issues[6].issue).to eq @issue7
          expect(read_issues[7].issue).to eq @issue8
          expect(read_issues[8].issue).to eq @issue9
          expect(read_issues[9].issue).to eq @issue10
        end

        it "sets a flash message" do
          expect(flash[:notice]).to eq "Successfully marked issues 1-10 as read"
        end

        it "redirects to the comic page" do
          expect(response).to redirect_to comic_path(@comic)
        end
      end
    end
  end

  describe "POST /refresh" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        comic = FactoryBot.create(:comic)
        post refresh_comic_path(comic)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is logged in" do
      before do
        sign_in FactoryBot.create(:user, :confirmed)
        @comic = FactoryBot.create(:comic)
      end

      it "starts a background refresh of the comic" do
        expect(ImportWorker).to receive(:perform_async).with("Comic", @comic.cv_id)
        post refresh_comic_path(@comic)
        expect(response).to redirect_to comic_path(@comic)
      end
    end
  end

  describe "POST /read_next_issue" do
    context "when user is not logged in" do
      it "redirects to the login page" do
        comic = FactoryBot.create(:comic)
        post read_next_issue_comic_path(comic)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when the user is logged in" do
      before do
        @user = FactoryBot.create(:user, :confirmed)
        sign_in @user
        @comic = FactoryBot.create(:comic)
      end

      context "when there is a next issue" do
        before do
          @issue = FactoryBot.create(:issue, comic: @comic)
        end

        it "creates a read issue" do
          post read_next_issue_comic_path(@comic)
          read_issue = ReadIssue.last
          expect(read_issue.issue).to eq @issue
          expect(read_issue.user).to eq @user
        end

        it "renders the progress sidebar" do
          post read_next_issue_comic_path(@comic)
          assert_select "#comic_progress"
        end
      end

      context "when there is no next issue" do
        it "does not create a read issue" do
          post read_next_issue_comic_path(@comic)
          expect(ReadIssue.last).to be_nil
        end
      end
    end
  end

  describe "POST /comics/:id/hide" do
    let(:user) { FactoryBot.create(:user, :confirmed) }
    let(:comic) { FactoryBot.create(:comic) }

    context "when user is not logged in" do
      it "redirects to the sign in page" do
        post hide_comic_path(comic)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is signed in" do
      before do
        sign_in user
      end

      it "creates a hidden comic" do
        post hide_comic_path(comic)
        hidden_comic = HiddenComic.last
        expect(hidden_comic.comic).to eq comic
        expect(hidden_comic.user).to eq user
      end

      it "renders the progress sidebar" do
        post hide_comic_path(comic)
        assert_select "#comic_progress"
      end
    end
  end

  describe "POST /comics/:id/unhide" do
    let(:user) { FactoryBot.create(:user, :confirmed) }
    let(:comic) { FactoryBot.create(:comic) }

    context "when user is not logged in" do
      it "redirects to the sign in page" do
        post unhide_comic_path(comic)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is signed in" do
      before do
        sign_in user
      end

      context "when a hidden comic is found" do
        before do
          FactoryBot.create(:hidden_comic, comic:, user:)
        end

        it "destroys the hidden comic" do
          post unhide_comic_path(comic)
          expect(HiddenComic.count).to eq 0
        end

        it "responds with a 200 ok" do
          post unhide_comic_path(comic)
          expect(response.status).to eq 200
        end
      end

      context "when a hidden comic is not found" do
        it "still responds with 200 ok" do
          post unhide_comic_path(comic)
          expect(response.status).to eq 200
        end
      end
    end
  end

  describe "GET /comics/:id/reviews" do
    it_behaves_like "a reviewable resource" do
      let(:resource) { FactoryBot.create(:comic) }
      let(:reviews_path) { reviews_comic_path(resource) }
      let(:resource_path) { comic_path(resource) }
    end
  end

  describe "POST /comics/:id/rate" do
    it_behaves_like "a rateable resource" do
      let(:resource) { FactoryBot.create(:comic) }
      let(:rate_path) { rate_comic_path(resource) }
    end
  end
end
