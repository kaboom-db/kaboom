require "rails_helper"

RSpec.describe Issue, type: :model do
  describe "associations" do
    it { should belong_to(:comic) }
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
