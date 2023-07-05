# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#strip_description" do
    context "when there is no description" do
      let(:description) { nil }

      it "returns an empty string" do
        expect(strip_description(description:)).to eq ""
      end
    end

    context "when there is a description" do
      let(:description) {
        "<style>h1 { color: red; }</style><script src='malicious.js'></script><a href='some/link/'><em>Comic</em></a> <figure><img src='hello.png'  /><img src='hello.png'></img></figure><p>Hello</p>"
      }

      it "strips all html tags" do
        expect(strip_description(description:)).to eq "h1 { color: red; }Comic Hello"
      end
    end
  end

  describe "#safe_description" do
    context "when there is no description" do
      let(:description) { nil }

      it "returns an empty string" do
        expect(safe_description(description:)).to eq ""
      end
    end

    context "when the is a description" do
      let(:description) {
        "<style>h1 { color: red; }</style><script src='malicious.js'></script><a href='some/link/'><em>Comic</em></a> <figure><img src='hello.png'  /><img src='hello.png'></img></figure><p>Hello</p>"
      }

      it "strips the unsafe html tags" do
        expect(safe_description(description:)).to eq "h1 { color: red; }<em>Comic</em> <p>Hello</p>"
      end
    end
  end
end
