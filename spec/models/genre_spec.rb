require "rails_helper"

RSpec.describe Genre, type: :model do
  describe "associations" do
    it { should have_and_belong_to_many(:comics) }
  end

  describe "#to_s" do
    it "returns the genre name" do
      expect(Genre.new(name: "Action").to_s).to eq "Action"
    end
  end
end
