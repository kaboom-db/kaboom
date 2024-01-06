RSpec.shared_examples "a statistics counter" do |klass, factory, date_field|
  let(:user) { FactoryBot.create(:user) }
  let(:counter) { klass.new(year:, user:) }

  before do
    issue1 = FactoryBot.create(:issue)
    issue2 = FactoryBot.create(:issue)

    extras1 = {}
    extras1[date_field] = Date.new(2020, 1, 1)
    extras2 = {}
    extras2[date_field] = Date.new(2023, 1, 1)

    @record1 = FactoryBot.create(factory, user:, issue: issue1, **extras1)
    @record2 = FactoryBot.create(factory, user:, issue: issue2, **extras2)
  end

  describe "#records" do
    context "when year is alltime" do
      let(:year) { "alltime" }

      it "returns all the #{factory} for the user" do
        expect(counter.records).to eq [@record1, @record2]
      end
    end

    context "when year is a real year" do
      let(:year) { 2023 }

      it "returns all the #{factory} for that year" do
        expect(counter.records).to eq [@record2]
      end
    end
  end

  describe "#count" do
    context "when year is alltime" do
      let(:year) { "alltime" }

      it "returns the full #{factory} count for the user" do
        expect(counter.count).to eq 2
      end
    end

    context "when year is a real year" do
      let(:year) { 2023 }

      it "returns the #{factory} count for that year" do
        expect(counter.count).to eq 1
      end
    end
  end
end
