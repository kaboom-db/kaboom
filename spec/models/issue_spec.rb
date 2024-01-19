require "rails_helper"

RSpec.describe Issue, type: :model do
  describe "associations" do
    it { should belong_to(:comic) }
    it { should have_many(:visits).dependent(:delete_all) }
    it { should have_many(:read_issues).dependent(:delete_all) }
  end

  describe "validations" do
    subject { FactoryBot.create(:issue) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:issue_number) }
    it { should validate_uniqueness_of(:issue_number).scoped_to(:comic_id) }
  end

  describe "scopes" do
    describe ".trending" do
      it_behaves_like "a trending resource", :issue
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
end
