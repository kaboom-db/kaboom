# frozen_string_literal: true

require "rails_helper"

module Base64
  RSpec.describe AssetConverter do
    let(:mime_type) { "font/ttf" }
    let(:converter) { AssetConverter.new(asset_path, mime_type) }

    subject { converter.convert }

    context "when asset does not exist" do
      let(:asset_path) { ["BOGUS", "PATH"] }

      it "returns an empty string" do
        expect(subject).to eq ""
      end
    end

    context "when asset exists" do
      let(:asset_path) { ["fonts", ".keep"] }

      it "converts the asset to base 64 with the provided mime type" do
        expect(subject).to eq "data:font/ttf;base64,VGhpcyBpcyBhIC5rZWVwIGZpbGUuIERvIG5vdCByZW1vdmUuCg=="
      end
    end
  end
end
