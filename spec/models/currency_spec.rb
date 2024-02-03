require "rails_helper"

RSpec.describe Currency, type: :model do
  describe "associations" do
    it { should have_many(:issues).dependent(:nullify) }
  end

  describe "validations" do
    subject { FactoryBot.build(:currency) }
    it { should validate_presence_of :symbol }
    it { should validate_presence_of :symbol_native }
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_uniqueness_of :code }
  end

  describe "#to_s" do
    it "returns the name" do
      expect(Currency.new(name: "Test").to_s).to eq "Test"
    end
  end
end
