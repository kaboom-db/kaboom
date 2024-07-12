require "rails_helper"

describe UserCollectionPresenter do
  describe "#user" do
    it "returns the user" do
      user = User.new
      expect(UserCollectionPresenter.new(user:).user).to eq user
    end
  end

  describe "#total_price_paid" do
    let(:user) { FactoryBot.create(:user) }

    subject { UserCollectionPresenter.new(user:).total_price_paid }

    context "when the user has no collected issues" do
      it { should eq 0 }
    end

    context "when the user has collected issues" do
      before do
        FactoryBot.create(:collected_issue, price_paid: 5.99, user:)
        FactoryBot.create(:collected_issue, price_paid: 10.99, user:)
      end

      it { should eq 16.98 }
    end
  end

  describe "#overall_collection_progress" do
    let(:user) { FactoryBot.create(:user) }

    subject { UserCollectionPresenter.new(user:).overall_collection_progress }

    context "when user has no collected issues" do
      it { should eq "0 / 0" }
    end

    context "when user has collected issues" do
      before do
        comic1 = FactoryBot.create(:comic, count_of_issues: 3)
        issue1 = FactoryBot.create(:issue, comic: comic1)
        issue2 = FactoryBot.create(:issue, comic: comic1)
        FactoryBot.create(:issue, comic: comic1)

        comic2 = FactoryBot.create(:comic, count_of_issues: 1)
        issue3 = FactoryBot.create(:issue, comic: comic2)

        FactoryBot.create(:collected_issue, issue: issue1, user:)
        FactoryBot.create(:collected_issue, issue: issue2, user:)
        FactoryBot.create(:collected_issue, issue: issue3, user:)
      end

      it { should eq "3 / 4" }
    end
  end

  describe "#grouped_collection" do
    let(:user) { FactoryBot.create(:user) }

    subject { UserCollectionPresenter.new(user:).grouped_collection }

    context "when user has no collected issues" do
      it { should eq({}) }
    end

    context "when user has collected issues" do
      before do
        @comic1 = FactoryBot.create(:comic, count_of_issues: 3)
        issue1 = FactoryBot.create(:issue, comic: @comic1, absolute_number: 1)
        issue2 = FactoryBot.create(:issue, comic: @comic1, absolute_number: 2)
        FactoryBot.create(:issue, comic: @comic1, absolute_number: 3)

        @comic2 = FactoryBot.create(:comic, count_of_issues: 1)
        issue3 = FactoryBot.create(:issue, comic: @comic2, absolute_number: 1)

        # Purposefully created the collected issues in this order to test sorting
        @collected_issue1 = FactoryBot.create(:collected_issue, issue: issue2, user:)
        @collected_issue2 = FactoryBot.create(:collected_issue, issue: issue3, user:)
        @collected_issue3 = FactoryBot.create(:collected_issue, issue: issue1, user:)
      end

      it "groups the collection by comic sorted by absolute number" do
        expect(subject).to eq({
          @comic1 => [@collected_issue3, @collected_issue1],
          @comic2 => [@collected_issue2]
        })
      end
    end
  end
end
