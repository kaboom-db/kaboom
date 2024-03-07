# frozen_string_literal: true

require "rails_helper"

module Charts
  RSpec.describe ChartCountGenerator do
    describe "#generate" do
      let(:generator) { ChartCountGenerator.new(resource: Issue.new, type: ChartCountGenerator::LINE) }

      subject { generator.generate }

      it "returns a hash with empty labels and dataset" do
        expect(subject).to eq(
          {
            labels: [],
            datasets: []
          }
        )
      end
    end
  end
end
