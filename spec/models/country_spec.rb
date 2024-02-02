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
end
