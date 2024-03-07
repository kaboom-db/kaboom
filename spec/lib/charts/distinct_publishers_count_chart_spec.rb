# frozen_string_literal: true

require "rails_helper"

module Charts
  RSpec.describe DistinctPublishersCountChart do
    describe "#generate" do
      let(:user) { FactoryBot.create(:user) }
      let(:date) { Date.new(2024, 1, 1) }
      let(:range) { date.beginning_of_year..date.end_of_year.end_of_day }
      let(:type) { ChartCountGenerator::LINE }
      let(:generator) { DistinctPublishersCountChart.new(resource: user, type:, range:) }

      subject { generator.generate }

      it "returns the counts for each publisher" do
        image = FactoryBot.create(:comic, publisher: "Image")
        image_issue = FactoryBot.create(:issue, comic: image)
        FactoryBot.create(:read_issue, user:, issue: image_issue, read_at: date - 1.second) # Not included
        FactoryBot.create(:read_issue, user:, issue: image_issue, read_at: date + 1.second) # Included
        FactoryBot.create(:read_issue, user:, issue: image_issue, read_at: date.end_of_year + 1.second) # Included
        FactoryBot.create(:read_issue, user:, issue: image_issue, read_at: date.end_of_year + 1.day) # Not included
        FactoryBot.create(:read_issue, user:, issue: image_issue, read_at: date + 1.day) # Included
        FactoryBot.create(:read_issue, user:, issue: image_issue, read_at: date + 7.days) # Included
        FactoryBot.create(:read_issue, user:, issue: image_issue, read_at: date + 1.month) # Included
        FactoryBot.create(:read_issue, user:, issue: image_issue, read_at: date + 7.months) # Included

        marvel = FactoryBot.create(:comic, publisher: "Marvel")
        marvel_issue = FactoryBot.create(:issue, comic: marvel)
        # Only five, will be collapsed into "Other"
        FactoryBot.create(:read_issue, user:, issue: marvel_issue, read_at: date + 1.day) # Included
        FactoryBot.create(:read_issue, user:, issue: marvel_issue, read_at: date + 7.days) # Included
        FactoryBot.create(:read_issue, user:, issue: marvel_issue, read_at: date + 1.month) # Included
        FactoryBot.create(:read_issue, user:, issue: marvel_issue, read_at: date + 7.months) # Included
        FactoryBot.create(:read_issue, user:, issue: marvel_issue, read_at: date + 8.months) # Included

        viz = FactoryBot.create(:comic, publisher: "Viz")
        viz_issue = FactoryBot.create(:issue, comic: viz)
        # Only two, will be collapsed into "Other"
        FactoryBot.create(:read_issue, user:, issue: viz_issue, read_at: date + 1.day) # Included
        FactoryBot.create(:read_issue, user:, issue: viz_issue, read_at: date + 7.days) # Included

        FactoryBot.create(:comic, publisher: "Dark Horse") # Will not be in the dataset labels

        expect(subject).to eq(
          {
            labels: ["Other", "Image"],
            datasets: [
              {
                type:,
                label: "Read Issues",
                backgroundColor: ChartCountGenerator::CHART_COLOURS.map { "rgba(#{_1}, 0.75)" },
                borderColor: "#000",
                borderWidth: 2,
                borderRadius: 15,
                fill: true,
                tension: 0.3,
                data: [7, 6]
              }
            ]
          }
        )
      end
    end
  end
end
