require "rails_helper"

RSpec.describe Issue, type: :model do
  describe "associations" do
    it { should belong_to(:comic) }
    it { should have_many(:visits) }
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
