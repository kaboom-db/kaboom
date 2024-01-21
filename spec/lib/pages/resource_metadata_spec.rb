# frozen_string_literal: true

require "rails_helper"

module Pages
  RSpec.describe ResourceMetadata do
    let(:resource) { FactoryBot.build(:comic, name: "Test", description: "This is a description", image: "image.png") }
    let(:metadata) { ResourceMetadata.new(resource:) }

    describe "#title" do
      it "returns the name" do
        expect(metadata.title).to eq "Test"
      end
    end

    describe "#description" do
      it "returns the description" do
        expect(metadata.description).to eq "This is a description"
      end
    end

    describe "#image" do
      it "returns the image" do
        expect(metadata.image).to eq "image.png"
      end
    end
  end
end
