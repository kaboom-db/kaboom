require "rails_helper"

RSpec.describe Issue, type: :model do
  describe "associations" do
    it { should belong_to(:comic) }
    it { should belong_to(:currency).optional }
    it { should have_many(:visits).dependent(:delete_all) }
    it { should have_many(:read_issues).dependent(:delete_all) }
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
end
