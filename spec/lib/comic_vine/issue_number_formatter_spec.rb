# frozen_string_literal: true

require "rails_helper"

module ComicVine
  RSpec.describe IssueNumberFormatter do
    describe ".format" do
      subject { IssueNumberFormatter.format(issue_number) }

      context "when issue number follows the 'plus' format" do
        let(:issue_number) { "18 + 1" }

        it "formats the issue number" do
          expect(subject).to eq 18.1
        end
      end

      context "when issue number follows the 'alphabetised' format" do
        context "when the number in the string is a float" do
          let(:issue_number) { "616.1b" }

          it "formats the issue number based off the letter" do
            expect(subject).to eq 616.12
          end
        end

        context "when the number in the string is not a float" do
          let(:issue_number) { "616c" }

          it "formats the issue number based off the letter" do
            expect(subject).to eq 616.3
          end
        end
      end

      context "when the issue number does not follow any format" do
        let(:issue_number) { "616.1.2a" } # This is NOT a real example of an issue number from ComicVine

        it "falls back to formatting as a float" do
          expect(subject).to eq 616.1
        end
      end
    end
  end
end
