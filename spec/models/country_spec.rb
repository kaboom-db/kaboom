require "rails_helper"

RSpec.describe Country, type: :model do
  describe "associations" do
    it { should have_many(:comics).dependent(:nullify) }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :language_code }
  end

  describe "#to_s" do
    it "returns the name of the country" do
      expect(Country.new(name: "England").to_s).to eq "England"
    end
  end

  describe "#colour" do
    let(:country) { Country.new(language_code:) }

    Country::COLOURS.each_pair do |language_code, colour|
      context "when language_code is #{language_code}" do
        let(:language_code) { language_code }

        it "returns the colour" do
          expect(country.colour).to eq colour
        end
      end
    end

    context "when language_code does not have a colour" do
      let(:language_code) { "bogus" }

      it "returns the default colour" do
        expect(country.colour).to eq "#ff5f6d"
      end
    end
  end
end
