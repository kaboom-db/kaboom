# frozen_string_literal: true

require "rails_helper"

module Charts
  RSpec.describe FrequencyChartGenerator do
    describe "#new" do
      let(:resource) { FactoryBot.build(:comic) }
      let(:num_of_elms) { 7 }
      let(:type) { ChartCountGenerator::LINE }
      let(:range_type) { FrequencyChartGenerator::DAY }
      let(:start_time) { Time.current }

      subject { FrequencyChartGenerator.new(resource:, num_of_elms:, type:, range_type:, start_time:) }

      context "when range type is valid" do
        it "does not raise an error" do
          expect { subject }.not_to raise_error
        end
      end

      context "when range type is not valid" do
        let(:range_type) { :bogus }

        it "raises an error" do
          expect { subject }.to raise_error("Invalid range type")
        end
      end
    end

    describe "#generate" do
      let(:generator) { FrequencyChartGenerator.new(resource:, num_of_elms:, type:, range_type:, start_time:) }
      let(:resource) { FactoryBot.build(:comic) }
      let(:num_of_elms) { 7 }
      let(:type) { ChartCountGenerator::LINE }
      let(:range_type) { FrequencyChartGenerator::DAY }
      let(:start_time) { Date.new(2024, 1, 1) }

      subject { generator.generate }

      context "when range type is days" do
        it "generates labels based off of num of elms, range type and start time" do
          data = subject
          expect(data[:datasets]).to eq []
          expect(data[:labels]).to eq ["Dec 26", "Dec 27", "Dec 28", "Dec 29", "Dec 30", "Dec 31", "Jan 1"]
        end
      end

      context "when range type is months" do
        let(:range_type) { FrequencyChartGenerator::MONTH }

        it "generates labels based off of num of elms, range type and start time" do
          data = subject
          expect(data[:datasets]).to eq []
          expect(data[:labels]).to eq ["Jul 2023", "Aug 2023", "Sep 2023", "Oct 2023", "Nov 2023", "Dec 2023", "Jan 2024"]
        end
      end

      context "when range type is years" do
        let(:range_type) { FrequencyChartGenerator::YEAR }

        it "generates labels based off of num of elms, range type and start time" do
          data = subject
          expect(data[:datasets]).to eq []
          expect(data[:labels]).to eq ["2018", "2019", "2020", "2021", "2022", "2023", "2024"]
        end
      end
    end
  end
end
