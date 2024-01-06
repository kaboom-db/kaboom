# frozen_string_literal: true

require "rails_helper"

module Statistics
  RSpec.describe BaseCount do
    let(:year) { 2023 }
    let(:user) { User.new }
    let(:base_count) { BaseCount.new(year:, user:) }

    describe "#records" do
      it "raises an error" do
        expect { base_count.records }.to raise_error("Implement in subclass")
      end
    end

    describe "#count" do
      it "raises an error" do
        expect { base_count.count }.to raise_error("Implement in subclass")
      end
    end
  end
end
