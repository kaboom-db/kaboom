# frozen_string_literal: true

require "rails_helper"

module Charts
  RSpec.describe UserCountsChart do
    describe "#generate" do
      let(:common_attributes) {
        {
          type:,
          borderWidth: 2,
          borderRadius: 15,
          fill: true,
          tension: 0.3
        }
      }
      let(:generator) { UserCountsChart.new(resource:, num_of_elms:, type:, range_type:, start_time:) }
      let(:resource) { FactoryBot.create(:user) }
      let(:num_of_elms) { 7 }
      let(:type) { Constants::LINE }
      let(:range_type) { FrequencyChartGenerator::DAY }
      let(:start_time) { Date.new(2024, 1, 1) }

      subject { generator.generate }

      def expect_dataset(dataset, label, rgb, data)
        expect(dataset).to eq(
          {
            label:,
            backgroundColor: [
              "rgba(#{rgb}, 0.75)"
            ],
            borderColor: "#000",
            data:
          }.merge(common_attributes)
        )
      end

      context "when range type is day" do
        it "returns the daily counts for the past num of elms" do
          [
            start_time,
            start_time + 1.second,
            start_time + 1.day,
            (start_time + 1.day) - 1.second,
            start_time - 6.days,
            start_time - 3.days,
            (start_time - 6.days) - 1.second
          ].each do |timestamp|
            FactoryBot.create(:read_issue, user: resource, read_at: timestamp)
            FactoryBot.create(:collected_issue, user: resource, collected_on: timestamp.to_date)
          end
          data = subject
          datasets = data[:datasets]
          expect_dataset(datasets.first, "Read issues", "255, 95, 109", [1, 0, 0, 1, 0, 0, 3])
          expect_dataset(datasets.second, "Collected issues", "71, 188, 234", [1, 0, 0, 1, 0, 0, 3])
        end
      end

      context "when range type is month" do
        let(:range_type) { FrequencyChartGenerator::MONTH }

        it "returns the monthly counts for the past num of elms" do
          [
            start_time,
            start_time + 1.second,
            start_time + 1.month,
            (start_time + 1.month) - 1.second,
            start_time - 6.months,
            start_time - 3.months,
            (start_time - 6.months) - 1.second
          ].each do |timestamp|
            FactoryBot.create(:read_issue, user: resource, read_at: timestamp)
            FactoryBot.create(:collected_issue, user: resource, collected_on: timestamp.to_date)
          end
          data = subject
          datasets = data[:datasets]
          expect_dataset(datasets.first, "Read issues", "255, 95, 109", [1, 0, 0, 1, 0, 0, 3])
          expect_dataset(datasets.second, "Collected issues", "71, 188, 234", [1, 0, 0, 1, 0, 0, 3])
        end
      end

      context "when range type is year" do
        let(:range_type) { FrequencyChartGenerator::YEAR }

        it "returns the yearly counts for the past num of elms" do
          [
            start_time,
            start_time + 1.second,
            start_time + 1.year,
            (start_time + 1.year) - 1.second,
            start_time - 6.years,
            start_time - 3.years,
            (start_time - 6.years) - 1.second
          ].each do |timestamp|
            FactoryBot.create(:read_issue, user: resource, read_at: timestamp)
            FactoryBot.create(:collected_issue, user: resource, collected_on: timestamp.to_date)
          end
          data = subject
          datasets = data[:datasets]
          expect_dataset(datasets.first, "Read issues", "255, 95, 109", [1, 0, 0, 1, 0, 0, 3])
          expect_dataset(datasets.second, "Collected issues", "71, 188, 234", [1, 0, 0, 1, 0, 0, 3])
        end
      end
    end
  end
end
