# frozen_string_literal: true

require "rails_helper"

module Charts::Stacked
  RSpec.describe GenreChart do
    let(:user) { FactoryBot.create(:user) }
    let(:range) { (Time.current.beginning_of_year..Time.current.end_of_year) }
    let(:chart) { GenreChart.new(user:, range:) }

    subject { chart.generate }

    context "when user has no read issues with a genre" do
      before do
        # Read within the range but has no genre
        FactoryBot.create(:read_issue, read_at: Time.current)
      end

      it { should eq [] }
    end

    context "when user has read issues with a genre" do
      before do
        genre1 = FactoryBot.create(:genre, name: "Adventure")
        genre2 = FactoryBot.create(:genre, name: "Action")

        comic1 = FactoryBot.create(:comic, genres: [genre2])
        comic2 = FactoryBot.create(:comic, genres: [genre2, genre1])

        issue1 = FactoryBot.create(:issue, comic: comic1)
        issue2 = FactoryBot.create(:issue, comic: comic1)
        issue3 = FactoryBot.create(:issue, comic: comic2)

        # User has read issue 1, but outside of the range
        FactoryBot.create(:read_issue, issue: issue1, user:, read_at: Time.current.beginning_of_year - 1.second)
        # User has read issue 2 once inside the range
        FactoryBot.create(:read_issue, issue: issue2, user:, read_at: Time.current.beginning_of_year)
        # User has read issue 3 multiple times, inside and out of range, but counted once
        FactoryBot.create(:read_issue, issue: issue3, user:, read_at: Time.current.beginning_of_year)
        FactoryBot.create(:read_issue, issue: issue3, user:, read_at: Time.current.beginning_of_year - 1.second)
        FactoryBot.create(:read_issue, issue: issue3, user:, read_at: Time.current)
        FactoryBot.create(:read_issue, issue: issue3, user:, read_at: Time.current.end_of_year)
      end

      it "returns the data with the percentages and counts" do
        expect(subject).to eq(
          [
            {
              name: "Action",
              percentage: 66.67,
              count: 2
            },
            {
              name: "Adventure",
              percentage: 33.33,
              count: 1
            }
          ]
        )
      end
    end
  end
end
