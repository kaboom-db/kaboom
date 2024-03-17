# frozen_string_literal: true

require "rails_helper"

module Base64
  RSpec.describe ImageUrlConverter do
    let(:image) { "" }
    let(:resource) { Issue.new(image:) }
    let(:converter) { ImageUrlConverter.new(resource) }

    subject { converter.convert(attribute) }

    context "when attribute does not exist on resource" do
      let(:attribute) { :bogus }

      it "returns an empty string" do
        expect(subject).to eq ""
      end
    end

    context "when the value of attribute is not a url" do
      let(:attribute) { :image }
      let(:image) { "bogus" }

      it "returns an empty string" do
        expect(subject).to eq ""
      end
    end

    context "when the request fails" do
      let(:attribute) { :image }
      let(:image) { "https://google.com" }

      before do
        stub_request(:get, image).to_return(status: 404)
      end

      it "returns an empty string" do
        expect(subject).to eq ""
      end
    end

    context "when the request succeeds with no content type" do
      let(:attribute) { :image }
      let(:image) { "https://google.com" }

      before do
        stub_request(:get, image).to_return(status: 200, body: "This is an image ;)")
      end

      it "returns the response body base64 encoded formatted as a data url, with the mime type defaulted to jpg" do
        expect(subject).to eq "data:image/jpg;base64,VGhpcyBpcyBhbiBpbWFnZSA7KQ=="
      end
    end

    context "when the request succeeds with content type set" do
      let(:attribute) { :image }
      let(:image) { "https://google.com" }
      let(:headers) { {"Content-Type" => "image/png"} }

      before do
        stub_request(:get, image).to_return(status: 200, body: "This is an image ;)", headers:)
      end

      it "returns the response body base64 encoded formatted as a data url" do
        expect(subject).to eq "data:image/png;base64,VGhpcyBpcyBhbiBpbWFnZSA7KQ=="
      end
    end
  end
end
