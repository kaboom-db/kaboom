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

  describe "#format_price" do
    let(:issue) { FactoryBot.create(:issue, cover_price: 3.99, currency:) }
    let(:currency) { FactoryBot.create(:currency, symbol_native: "£", placement:) }

    subject { format_price(issue:) }

    context "when there is no currency" do
      let(:currency) { nil }

      it "returns the cover price" do
        expect(subject).to eq 3.99
      end
    end

    context "when there is no placement" do
      let(:placement) { "" }

      it "defaults to the start of the value" do
        expect(subject).to eq "£3.99"
      end
    end

    context "when placement is start" do
      let(:placement) { Currency::VALUE_START }

      it "places the symbol at the start" do
        expect(subject).to eq "£3.99"
      end
    end

    context "when placement is end" do
      let(:placement) { Currency::VALUE_END }

      it "places the symbol at the end" do
        expect(subject).to eq "3.99£"
      end
    end
  end
end
