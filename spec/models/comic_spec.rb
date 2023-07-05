require "rails_helper"

RSpec.describe Comic, type: :model do
  describe "associations" do
    it { should have_many(:issues) }
    it { should have_many(:ordered_issues).class_name("Issue") }
    it { should have_many(:visits) }
  end

  describe "validations" do
    subject { FactoryBot.create(:comic) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cv_id) }
    it { should validate_uniqueness_of(:cv_id) }
  end

  describe "scopes" do
    describe ".trending" do
      it_behaves_like "a trending resource", :comic
    end
  end

  describe "#aliases_to_array" do
    before do
      @comic = FactoryBot.create(:comic, aliases:)
    end

    context "when there are no aliases" do
      let(:aliases) { nil }

      it "returns an empty array" do
        expect(@comic.aliases_to_array).to eq []
      end
    end

    context "when there are aliases" do
      let(:aliases) { "Hello\nThere\nSpider-Man" }

      it "returns an array with the aliases" do
        expect(@comic.aliases_to_array).to eq ["Hello", "There", "Spider-Man"]
      end

      context "when there are empty aliases" do
        let(:aliases) { "Hello\n\nThere\nSpider-Man\n" }

        it "does not return the empty aliases" do
          expect(@comic.aliases_to_array).to eq ["Hello", "There", "Spider-Man"]
        end
      end
    end
  end

  describe "#search" do
    it "searches by name and alias" do
      comic_1 = FactoryBot.create(:comic, name: "Test Comic")
      comic_2 = FactoryBot.create(:comic, aliases: "Comic\nTesting", name: "Cool Comic")
      comic_3 = FactoryBot.create(:comic, aliases: "Comic", name: "No Name")
      results = Comic.search(query: "test")
      expect(results).to contain_exactly(comic_1, comic_2)
    end
  end

  describe "ComicVine API" do
    let!(:comic) {
      FactoryBot.create(
        :comic,
        aliases: "Something",
        api_detail_url: "google.com",
        count_of_issues: 1,
        date_last_updated: "2023-03-31 13:00:51",
        deck: "Volume 1",
        description: "This is a description",
        cv_id: 63559,
        image: "google.com",
        name: "Hello world",
        publisher: "Marvel",
        site_detail_url: "google.com",
        start_year: 2013
      )
    }
    let(:cv_id) { 63559 }
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
          id: cv_id,
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

    describe ".import" do
      context "when the comic with the ComicVine ID exists" do
        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
            }
          }
          let(:endpoint) { "volume/4050-63559/" }
          let(:response) { {status: 200, body:} }
        end

        it "updates the existing record" do
          Comic.import(comic_vine_id: 63559)
          comic.reload
          expect(comic.aliases).to eq "Some Alias"
          expect(comic.api_detail_url).to eq "https://comicvine.gamespot.com/api/volume/4050-63559/"
          expect(comic.count_of_issues).to eq 5
          expect(comic.date_last_updated).to eq DateTime.parse("2023-03-31 14:58:51")
          expect(comic.deck).to eq "Some Deck"
          expect(comic.description).to eq "<p>Published by the German wing of Panini Comics.</p>"
          expect(comic.cv_id).to eq 63559
          expect(comic.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11/119711/3109464-ultimatecomicsspiderman1_831.jpg"
          expect(comic.name).to eq "Ultimate Comics: Spider-Man"
          expect(comic.publisher).to eq "Panini Verlag"
          expect(comic.site_detail_url).to eq "https://comicvine.gamespot.com/ultimate-comics-spider-man/4050-63559/"
          expect(comic.start_year).to eq 2012
        end

        it "returns the imported comic" do
          expect(Comic.import(comic_vine_id: 63559)).to eq comic
        end
      end

      context "when the comic with the ComicVine ID does not exist" do
        let(:cv_id) { 12345 }

        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
            }
          }
          let(:endpoint) { "volume/4050-12345/" }
          let(:response) { {status: 200, body:} }
        end

        it "creates a new Comic" do
          Comic.import(comic_vine_id: 12345)
          new_comic = Comic.last
          expect(new_comic.aliases).to eq "Some Alias"
          expect(new_comic.api_detail_url).to eq "https://comicvine.gamespot.com/api/volume/4050-63559/"
          expect(new_comic.count_of_issues).to eq 5
          expect(new_comic.date_last_updated).to eq DateTime.parse("2023-03-31 14:58:51")
          expect(new_comic.deck).to eq "Some Deck"
          expect(new_comic.description).to eq "<p>Published by the German wing of Panini Comics.</p>"
          expect(new_comic.cv_id).to eq 12345
          expect(new_comic.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11/119711/3109464-ultimatecomicsspiderman1_831.jpg"
          expect(new_comic.name).to eq "Ultimate Comics: Spider-Man"
          expect(new_comic.publisher).to eq "Panini Verlag"
          expect(new_comic.site_detail_url).to eq "https://comicvine.gamespot.com/ultimate-comics-spider-man/4050-63559/"
          expect(new_comic.start_year).to eq 2012
          expect(Comic.count).to eq 2
        end

        it "returns the imported comic" do
          expect(Comic.import(comic_vine_id: 12345)).to eq Comic.last
        end
      end
    end

    describe "#import_issues" do
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

      include_context "stub ComicVine API request" do
        let(:options) {
          {
            field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume",
            filter: "volume:63559",
            offset: 0
          }
        }
        let(:endpoint) { "issues/" }
        let(:response) { {status: 200, body: {results:}.to_json} }
      end

      context "when issues exist" do
        before do
          @issue = FactoryBot.create(:issue, comic:, cv_id: 123)
        end

        it "updates the existing issues" do
          comic.import_issues
          @issue.reload
          expect(@issue.aliases).to eq nil
          expect(@issue.api_detail_url).to eq "https://comicvine.gamespot.com/api/issue/4000-129176/"
          expect(@issue.cover_date).to eq Date.parse("1997-12-29")
          expect(@issue.date_last_updated).to eq DateTime.parse("2022-05-31 19:47:55")
          expect(@issue.deck).to eq nil
          expect(@issue.description).to eq "A really long description"
          expect(@issue.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11136/111369808/6786544-one%20piece%201.jpg"
          expect(@issue.issue_number).to eq 1
          expect(@issue.name).to eq "Romance Dawn: Bōken no Yoake"
          expect(@issue.site_detail_url).to eq "https://comicvine.gamespot.com/one-piece-1-romance-dawn-boken-no-yoake/4000-129176/"
          expect(@issue.store_date).to eq Date.parse("1997-12-24")
        end

        it "creates new issues" do
          comic.import_issues
          new_issue = Issue.last
          expect(new_issue.aliases).to eq nil
          expect(new_issue.api_detail_url).to eq "https://comicvine.gamespot.com/api/issue/4000-129185/"
          expect(new_issue.cover_date).to eq Date.parse("1998-04-08")
          expect(new_issue.date_last_updated).to eq DateTime.parse("2023-04-21 18:56:34")
          expect(new_issue.deck).to eq nil
          expect(new_issue.description).to eq "AN EVEN LONGER DESCRIPTION"
          expect(new_issue.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11136/111369808/6786545-one%20piece%202.jpg"
          expect(new_issue.issue_number).to eq 2.1
          expect(new_issue.name).to eq "Versus!! Buggy Kaizoku-Dan"
          expect(new_issue.site_detail_url).to eq "https://comicvine.gamespot.com/one-piece-2-versus-buggy-kaizoku-dan/4000-129185/"
          expect(new_issue.store_date).to eq Date.parse("1998-04-03")
          expect(Issue.count).to eq 2
        end
      end

      context "when issues do not exist" do
        it "creates new issues" do
          comic.import_issues
          new_issue1 = Issue.first
          expect(new_issue1.aliases).to eq nil
          expect(new_issue1.api_detail_url).to eq "https://comicvine.gamespot.com/api/issue/4000-129176/"
          expect(new_issue1.cover_date).to eq Date.parse("1997-12-29")
          expect(new_issue1.date_last_updated).to eq DateTime.parse("2022-05-31 19:47:55")
          expect(new_issue1.deck).to eq nil
          expect(new_issue1.description).to eq "A really long description"
          expect(new_issue1.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11136/111369808/6786544-one%20piece%201.jpg"
          expect(new_issue1.issue_number).to eq 1
          expect(new_issue1.name).to eq "Romance Dawn: Bōken no Yoake"
          expect(new_issue1.site_detail_url).to eq "https://comicvine.gamespot.com/one-piece-1-romance-dawn-boken-no-yoake/4000-129176/"
          expect(new_issue1.store_date).to eq Date.parse("1997-12-24")

          new_issue2 = Issue.last
          expect(new_issue2.aliases).to eq nil
          expect(new_issue2.api_detail_url).to eq "https://comicvine.gamespot.com/api/issue/4000-129185/"
          expect(new_issue2.cover_date).to eq Date.parse("1998-04-08")
          expect(new_issue2.date_last_updated).to eq DateTime.parse("2023-04-21 18:56:34")
          expect(new_issue2.deck).to eq nil
          expect(new_issue2.description).to eq "AN EVEN LONGER DESCRIPTION"
          expect(new_issue2.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11136/111369808/6786545-one%20piece%202.jpg"
          expect(new_issue2.issue_number).to eq 2.1
          expect(new_issue2.name).to eq "Versus!! Buggy Kaizoku-Dan"
          expect(new_issue2.site_detail_url).to eq "https://comicvine.gamespot.com/one-piece-2-versus-buggy-kaizoku-dan/4000-129185/"
          expect(new_issue2.store_date).to eq Date.parse("1998-04-03")
          expect(Issue.count).to eq 2
        end
      end
    end

    describe "#sync" do
      context "when the corresponding record exists on ComicVine" do
        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
            }
          }
          let(:endpoint) { "volume/4050-63559/" }
          let(:response) { {status: 200, body:} }
        end

        it "updates the comic with the ComicVine results" do
          comic.sync
          expect(comic.aliases).to eq "Some Alias"
          expect(comic.api_detail_url).to eq "https://comicvine.gamespot.com/api/volume/4050-63559/"
          expect(comic.count_of_issues).to eq 5
          expect(comic.date_last_updated).to eq DateTime.parse("2023-03-31 14:58:51")
          expect(comic.deck).to eq "Some Deck"
          expect(comic.description).to eq "<p>Published by the German wing of Panini Comics.</p>"
          expect(comic.cv_id).to eq 63559
          expect(comic.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11/119711/3109464-ultimatecomicsspiderman1_831.jpg"
          expect(comic.name).to eq "Ultimate Comics: Spider-Man"
          expect(comic.publisher).to eq "Panini Verlag"
          expect(comic.site_detail_url).to eq "https://comicvine.gamespot.com/ultimate-comics-spider-man/4050-63559/"
          expect(comic.start_year).to eq 2012
        end

        it "returns a truthy value" do
          expect(comic.sync).to be_truthy
        end
      end

      context "when the ComicVine api request fails" do
        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
            }
          }
          let(:endpoint) { "volume/4050-63559/" }
          let(:response) { {status: 404} }
        end

        it "does not update the comic" do
          comic.sync
          expect(comic.aliases).to eq "Something"
          expect(comic.api_detail_url).to eq "google.com"
          expect(comic.count_of_issues).to eq 1
          expect(comic.date_last_updated).to eq DateTime.parse("2023-03-31 13:00:51")
          expect(comic.deck).to eq "Volume 1"
          expect(comic.description).to eq "This is a description"
          expect(comic.cv_id).to eq 63559
          expect(comic.image).to eq "google.com"
          expect(comic.name).to eq "Hello world"
          expect(comic.publisher).to eq "Marvel"
          expect(comic.site_detail_url).to eq "google.com"
          expect(comic.start_year).to eq 2013
        end

        it "returns a falsey value" do
          expect(comic.sync).to be_falsey
        end
      end

      context "when ComicVine responds with an error" do
        let(:body) {
          {
            error: "Object not found."
          }.to_json
        }

        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "id,aliases,api_detail_url,count_of_issues,date_last_updated,deck,description,image,name,publisher,site_detail_url,start_year,created_at,updated_at"
            }
          }
          let(:endpoint) { "volume/4050-63559/" }
          let(:response) { {status: 200, body:} }
        end

        it "returns a falsey value" do
          expect(comic.sync).to be_falsey
        end
      end
    end
  end
end
