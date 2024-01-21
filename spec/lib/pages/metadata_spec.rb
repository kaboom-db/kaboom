# frozen_string_literal: true

require "rails_helper"

module Pages
  RSpec.describe Metadata do
    let(:metadata) { Metadata.new }

    describe "#title" do
      it "raises an error" do
        expect { metadata.title }.to raise_error("Implement in subclass")
      end
    end

    describe "#description" do
      it "raises an error" do
        expect { metadata.description }.to raise_error("Implement in subclass")
      end
    end

    describe "#image" do
      it "raises an error" do
        expect { metadata.image }.to raise_error("Implement in subclass")
      end
    end
  end
end
