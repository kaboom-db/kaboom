require "rails_helper"

RSpec.describe Issue, type: :model do
  describe "associations" do
    it { should belong_to(:comic) }
    it { should have_many(:visits).dependent(:delete_all) }
    it { should have_many(:read_issues).dependent(:delete_all) }
    it { should have_many(:collected_issues).dependent(:delete_all) }
    it { should have_many(:ratings).dependent(:delete_all) }
  end

  describe "validations" do
    subject { FactoryBot.create(:issue, issue_number: "616a") }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:issue_number) }
    it { should validate_presence_of(:absolute_number) }
    it { should validate_uniqueness_of(:issue_number).scoped_to(:comic_id) }

    context "when isbn is valid isbn13" do
      it "is valid" do
        issue = FactoryBot.build(:issue, isbn: "978-1-56619-909-4")
        expect(issue.valid?).to eq true
      end
    end

    context "when isbn is valid isbn10" do
      it "is valid" do
        issue = FactoryBot.build(:issue, isbn: "1-56619-909-3")
        expect(issue.valid?).to eq true
      end
    end

    context "when isbn is invalid" do
      it "is not valid" do
        issue = FactoryBot.build(:issue, isbn: "bogus isbn")
        expect(issue.valid?).to eq false
      end
    end
  end

  describe "scopes" do
    describe ".trending" do
      it_behaves_like "a trending resource", :issue
    end

    describe ".safe_for_work" do
      it "only returns the safe for work comics" do
        nsfw = FactoryBot.create(:comic, nsfw: true)
        FactoryBot.create(:issue, comic: nsfw)
        issue = FactoryBot.create(:issue)
        expect(Issue.safe_for_work).to eq [issue]
      end
    end
  end

  describe "callbacks" do
    describe "after_create :create_notifications" do
      let(:comic) { FactoryBot.create(:comic) }
      let(:issue1) { FactoryBot.create(:issue, comic:) }
      let(:issue2) { FactoryBot.build(:issue, comic:) }

      context "when there are no users reading the comic" do
        it "does not create any notifications" do
          issue2.save
          expect(Notification.count).to eq 0
        end
      end

      context "when there are users reading the comic" do
        it "creates the notifications for the users" do
          user1 = FactoryBot.create(:read_issue, issue: issue1).user
          user2 = FactoryBot.create(:read_issue, issue: issue1).user
          issue2.save

          expect(Notification.count).to eq 2
          notification1 = Notification.where(user: user1).first
          expect(notification1.notifiable).to eq issue2
          expect(notification1.notification_type).to eq Notification::NEW_ISSUE

          notification2 = Notification.where(user: user2).first
          expect(notification2.notifiable).to eq issue2
          expect(notification2.notification_type).to eq Notification::NEW_ISSUE
        end
      end
    end
  end

  describe "#year" do
    context "when there is a store date" do
      it "returns the year of the store date" do
        issue = FactoryBot.build(:issue, store_date: Date.new(2024, 1, 1))
        expect(issue.year).to eq 2024
      end
    end

    context "when there is no store date" do
      it "returns nil" do
        issue = FactoryBot.build(:issue, store_date: nil)
        expect(issue.year).to eq nil
      end
    end
  end

  describe "#formatted_issue_number" do
    let(:issue) { FactoryBot.create(:issue, issue_number:) }

    context "when there is a trailing .0" do
      let(:issue_number) { 1 }

      it "strips the .0" do
        expect(issue.formatted_issue_number).to eq "1"
      end
    end

    context "when there is no trailing .0" do
      let(:issue_number) { 1.01 }

      it "returns the issue number as a string" do
        expect(issue.formatted_issue_number).to eq "1.01"
      end
    end
  end

  describe "#next" do
    let(:comic) { FactoryBot.create(:comic) }

    context "when there is a next issue" do
      before do
        @issue = FactoryBot.create(:issue, comic:, absolute_number: 1)
        @issue2 = FactoryBot.create(:issue, comic:, absolute_number: 2)
      end

      it "returns the next issue according to the absolute number" do
        expect(@issue.next).to eq @issue2
      end
    end

    context "when there is no next issue" do
      before do
        @issue = FactoryBot.create(:issue, comic:, absolute_number: 2)
        # Issue isn't part of the comic
        FactoryBot.create(:issue, absolute_number: 3)
      end

      it "returns the next issue according to the absolute number" do
        expect(@issue.next).to be_nil
      end
    end
  end

  describe "ComicVine API" do
    let!(:issue) { FactoryBot.create(:issue, cv_id: 123) }
    let(:body) {
      {
        error: "OK",
        results: {
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
        }
      }.to_json
    }

    describe ".import" do
      subject { Issue.import(comic_vine_id:) }

      context "when the issue with the ComicVine id exists" do
        let(:comic_vine_id) { 123 }

        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume"
            }
          }
          let(:endpoint) { "issue/4000-123/" }
          let(:response) { {status: 200, body:} }
        end

        it "updates the issue" do
          subject
          issue.reload
          expect(issue.aliases).to be_nil
          expect(issue.api_detail_url).to eq "https://comicvine.gamespot.com/api/issue/4000-129176/"
          expect(issue.cover_date).to eq Date.parse("1997-12-29")
          expect(issue.date_last_updated).to eq DateTime.parse("2022-05-31 19:47:55")
          expect(issue.deck).to be_nil
          expect(issue.description).to eq "A really long description"
          expect(issue.cv_id).to eq 123
          expect(issue.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11136/111369808/6786544-one%20piece%201.jpg"
          expect(issue.issue_number).to eq "1"
          expect(issue.name).to eq "Romance Dawn: Bōken no Yoake"
          expect(issue.site_detail_url).to eq "https://comicvine.gamespot.com/one-piece-1-romance-dawn-boken-no-yoake/4000-129176/"
          expect(issue.store_date).to eq Date.parse("1997-12-24")
        end

        it "returns the issue" do
          expect(subject).to eq issue
        end
      end

      context "when the issue with the ComicVin id does not exist" do
        let(:comic_vine_id) { 1234 }

        it "returns nil" do
          expect(subject).to be_nil
        end
      end
    end

    describe "#sync" do
      subject { issue.sync }

      context "when the ComicVine api request succeeds" do
        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume"
            }
          }
          let(:endpoint) { "issue/4000-123/" }
          let(:response) { {status: 200, body:} }
        end

        it "updates the issue" do
          subject
          issue.reload
          expect(issue.aliases).to be_nil
          expect(issue.api_detail_url).to eq "https://comicvine.gamespot.com/api/issue/4000-129176/"
          expect(issue.cover_date).to eq Date.parse("1997-12-29")
          expect(issue.date_last_updated).to eq DateTime.parse("2022-05-31 19:47:55")
          expect(issue.deck).to be_nil
          expect(issue.description).to eq "A really long description"
          expect(issue.cv_id).to eq 123
          expect(issue.image).to eq "https://comicvine.gamespot.com/a/uploads/scale_medium/11136/111369808/6786544-one%20piece%201.jpg"
          expect(issue.issue_number).to eq "1"
          expect(issue.name).to eq "Romance Dawn: Bōken no Yoake"
          expect(issue.site_detail_url).to eq "https://comicvine.gamespot.com/one-piece-1-romance-dawn-boken-no-yoake/4000-129176/"
          expect(issue.store_date).to eq Date.parse("1997-12-24")
        end

        it "returns a truthy value" do
          expect(subject).to be_truthy
        end
      end

      context "when the ComicVine api request does not succeed" do
        include_context "stub ComicVine API request" do
          let(:options) {
            {
              field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume"
            }
          }
          let(:endpoint) { "issue/4000-123/" }
          let(:response) { {status: 404} }
        end

        it "returns a falsey value" do
          expect(subject).to be_falsey
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
              field_list: "aliases,api_detail_url,cover_date,date_last_updated,deck,description,id,image,issue_number,name,site_detail_url,store_date,volume"
            }
          }
          let(:endpoint) { "issue/4000-123/" }
          let(:response) { {status: 200, body:} }
        end

        it "returns a falsey value" do
          expect(subject).to be_falsey
        end
      end
    end
  end
end
