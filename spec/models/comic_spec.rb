require "rails_helper"

RSpec.describe Comic, type: :model do
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
      end
    end

    describe ".sync" do
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
          Comic.sync(comic:)
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

        it "returns a truthy value" do
          expect(Comic.sync(comic:)).to be_truthy
        end
      end

      context "when the corresponding record does not exist on ComicVine" do
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
          Comic.sync(comic:)
          comic.reload
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
          expect(Comic.sync(comic:)).to be_falsey
        end
      end
    end
  end
end
