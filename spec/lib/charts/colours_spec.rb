# frozen_string_literal: true

require "rails_helper"

module Charts
  RSpec.describe Colours do
    describe "#next" do
      let(:colours) { Colours.new }

      it "returns an rgb colour" do
        Constants::CHART_COLOURS.count.times { expect(colours.next).to match(/\d{1,3}, \d{1,3}, \d{1,3}$/) }
      end

      it "returns a different colour each time" do
        expect(colours.next).not_to eq(colours.next)
      end

      context "when the colours run out" do
        it "cycles the colours" do
          Constants::CHART_COLOURS.count.times { colours.next }
          expect(colours.next).to eq Constants::CHART_COLOURS.first
        end
      end
    end
  end
end
