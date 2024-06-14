require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:read_issues).dependent(:delete_all) }
    it { should have_many(:comics).through(:read_issues) }
    it { should have_many(:issues_read).through(:read_issues).source(:issue) }

    it { should have_many(:visits).dependent(:delete_all) }

    it { should have_many(:wishlist_items).dependent(:delete_all) }
    it { should have_many(:wishlisted_comics).through(:wishlist_items).class_name("Comic") }
    it { should have_many(:wishlisted_issues).through(:wishlist_items).class_name("Issue") }

    it { should have_many(:favourite_items).dependent(:delete_all) }
    it { should have_many(:favourited_comics).through(:favourite_items).class_name("Comic") }
    it { should have_many(:favourited_issues).through(:favourite_items).class_name("Issue") }

    it { should have_many(:collected_issues).dependent(:delete_all) }
    it { should have_many(:collection).through(:collected_issues).source(:issue) }

    it { should have_many(:follow_ers).class_name("Follow") }
    it { should have_many(:followers).through(:follow_ers).source(:follower) }

    it { should have_many(:follow_ing).class_name("Follow") }
    it { should have_many(:following).through(:follow_ing).source(:target) }
  end

  describe "validations" do
    subject { FactoryBot.create(:user) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end

  describe "#avatar" do
    let(:user) { FactoryBot.build(:user, :confirmed, email: "hello@there.obi") }

    it "gets the avatar for the user from Gravatar" do
      expect(user.avatar).to eq "https://www.gravatar.com/avatar/898e4fc667e28813fe2ba58a7cec6286?d=retro"
    end
  end

  describe "#image" do
    let(:user) { FactoryBot.build(:user, :confirmed, email: "hello@there.obi") }

    it "returns the avatar" do
      expect(user.image).to eq "https://www.gravatar.com/avatar/898e4fc667e28813fe2ba58a7cec6286?d=retro"
    end
  end

  describe "#name" do
    let(:user) { FactoryBot.build(:user, :confirmed, username: "obi1") }

    it "returns the username" do
      expect(user.name).to eq "obi1"
    end
  end

  describe "#to_param" do
    let(:user) { FactoryBot.build(:user, username: "ObiWan") }

    it "returns the username" do
      expect(user.to_param).to eq "ObiWan"
    end
  end

  describe "#to_s" do
    let(:user) { FactoryBot.build(:user, username: "ObiWan") }

    it "returns the username" do
      expect(user.to_s).to eq "ObiWan"
    end
  end

  describe "#last_read_issue" do
    let(:user) { FactoryBot.create(:user, username: "ObiWan") }

    context "when there is no last read issue" do
      it "returns nil" do
        expect(user.last_read_issue).to be_nil
      end
    end

    context "when there are read issues" do
      it "returns the last read issue" do
        FactoryBot.create(:read_issue, user:, read_at: Time.current - 2.seconds)
        issue = FactoryBot.create(:read_issue, user:, read_at: Time.current - 1.second)
        FactoryBot.create(:read_issue, user:, read_at: Time.current - 3.seconds)
        expect(user.last_read_issue).to eq issue
      end
    end
  end

  describe "#first_read_issue" do
    let(:user) { FactoryBot.create(:user, username: "ObiWan") }

    context "when year is invalid" do
      it "returns nil" do
        expect(user.first_read_issue(year: "gobble-di-guck")).to be_nil
      end
    end

    context "when year is all time" do
      it "returns the first read issue" do
        issue = FactoryBot.create(:read_issue, user:, read_at: Time.current - 2.years)
        FactoryBot.create(:read_issue, user:, read_at: Time.current - 1.years)
        expect(user.first_read_issue(year: "alltime")).to eq issue
      end
    end

    context "when year is a valid year" do
      it "returns the first read issue for that year" do
        year = Time.new(2024, 1, 1, 14, 0)
        FactoryBot.create(:read_issue, user:, read_at: (year - 1.years) + 5.days)
        issue = FactoryBot.create(:read_issue, user:, read_at: year - 1.years)
        FactoryBot.create(:read_issue, user:, read_at: year)
        FactoryBot.create(:read_issue, user:, read_at: year - 3.years)
        expect(user.first_read_issue(year: "2023")).to eq issue
      end

      context "when there are no read issues" do
        it "returns nil" do
          expect(user.first_read_issue(year: "2024")).to be_nil
        end
      end
    end
  end

  describe "#first_collected_issue" do
    let(:user) { FactoryBot.create(:user, username: "ObiWan") }

    context "when year is invalid" do
      it "returns nil" do
        expect(user.first_collected_issue(year: "gobble-di-guck")).to be_nil
      end
    end

    context "when year is all time" do
      it "returns the first collected issue" do
        issue = FactoryBot.create(:collected_issue, user:, collected_on: Time.current - 2.years)
        FactoryBot.create(:collected_issue, user:, collected_on: Time.current - 1.years)
        expect(user.first_collected_issue(year: "alltime")).to eq issue
      end
    end

    context "when year is a valid year" do
      it "returns the first collected issue for that year" do
        year = Time.new(2024, 1, 1, 14, 0)
        FactoryBot.create(:collected_issue, user:, collected_on: (year - 1.years) + 5.days)
        issue = FactoryBot.create(:collected_issue, user:, collected_on: year - 1.years)
        FactoryBot.create(:collected_issue, user:, collected_on: year)
        FactoryBot.create(:collected_issue, user:, collected_on: year - 3.years)
        expect(user.first_collected_issue(year: "2023")).to eq issue
      end

      context "when there are no collected issues" do
        it "returns nil" do
          expect(user.first_collected_issue(year: "2024")).to be_nil
        end
      end
    end
  end

  describe "#progress_for" do
    let(:user) { FactoryBot.create(:user) }

    before do
      @comic = FactoryBot.create(:comic, count_of_issues: 3)
      issue1 = FactoryBot.create(:issue, comic: @comic)
      issue2 = FactoryBot.create(:issue, comic: @comic)
      # Issue does not belong to this comic
      issue3 = FactoryBot.create(:issue, absolute_number: 3)

      FactoryBot.create(:read_issue, issue: issue1, user:)
      FactoryBot.create(:read_issue, issue: issue2, user:)
      FactoryBot.create(:read_issue, issue: issue1, user:)
      FactoryBot.create(:read_issue, issue: issue3, user:)
    end

    it "returns the percentage read of a comic, rounded down" do
      expect(user.progress_for(@comic)).to eq 66
    end
  end

  describe "#read_issues_for" do
    let(:user) { FactoryBot.create(:user) }

    before do
      @comic = FactoryBot.create(:comic, count_of_issues: 3)
      issue1 = FactoryBot.create(:issue, comic: @comic, absolute_number: 1)
      issue2 = FactoryBot.create(:issue, comic: @comic, absolute_number: 2)
      # Issue does not belong to this comic
      issue3 = FactoryBot.create(:issue, absolute_number: 3)

      @ri1 = FactoryBot.create(:read_issue, issue: issue1, user:, read_at: Time.current - 10.seconds)
      @ri2 = FactoryBot.create(:read_issue, issue: issue2, user:, read_at: Time.current - 4.seconds)
      @ri3 = FactoryBot.create(:read_issue, issue: issue2, user:, read_at: Time.current - 5.seconds)
      @ri4 = FactoryBot.create(:read_issue, issue: issue1, user:, read_at: Time.current + 10.seconds)
      FactoryBot.create(:read_issue, issue: issue3, user:, read_at: Time.current + 15.seconds)
    end

    it "returns all the read issues of the comic for the user, ordered by absolute_number and read_at DESC" do
      expect(user.read_issues_for(@comic)).to eq [@ri2, @ri3, @ri4, @ri1]
    end
  end

  describe "#next_up_for" do
    let(:user) { FactoryBot.create(:user) }
    let(:comic) { FactoryBot.create(:comic) }

    before do
      @issue1 = FactoryBot.create(:issue, comic:, absolute_number: 1)
      @issue2 = FactoryBot.create(:issue, comic:, absolute_number: 2)
      @issue3 = FactoryBot.create(:issue, comic:, absolute_number: 3)
      @issue4 = FactoryBot.create(:issue, comic:, absolute_number: 4)
    end

    context "when the user has not read any issues in the comic" do
      it "returns the first issue" do
        expect(user.next_up_for(comic)).to eq @issue1
      end
    end

    context "when the user has read an issue in the comic" do
      before do
        FactoryBot.create(:read_issue, issue: @issue3, user:)
      end

      it "returns the next issue relative to the highest issue read" do
        expect(user.next_up_for(comic)).to eq @issue4
      end
    end

    context "when the user has read the first and last issue but missed some in between" do
      before do
        FactoryBot.create(:read_issue, issue: @issue1, user:)
        FactoryBot.create(:read_issue, issue: @issue2, user:)
        FactoryBot.create(:read_issue, issue: @issue4, user:)
      end

      it "returns the first unread issue" do
        expect(user.next_up_for(comic)).to eq @issue3
      end
    end

    context "when the user has read all the issues in the comic" do
      before do
        FactoryBot.create(:read_issue, issue: @issue1, user:)
        FactoryBot.create(:read_issue, issue: @issue2, user:)
        FactoryBot.create(:read_issue, issue: @issue3, user:)
        FactoryBot.create(:read_issue, issue: @issue4, user:)
      end

      it "returns nil" do
        expect(user.next_up_for(comic)).to be_nil
      end
    end
  end

  describe "#completed_comics" do
    let(:user) { FactoryBot.create(:user) }

    before do
      @comic1 = FactoryBot.create(:comic, count_of_issues: 2)
      issue1 = FactoryBot.create(:issue, comic: @comic1)
      FactoryBot.create(:issue, comic: @comic1)

      @comic2 = FactoryBot.create(:comic, count_of_issues: 2)
      issue3 = FactoryBot.create(:issue, comic: @comic2)
      issue4 = FactoryBot.create(:issue, comic: @comic2)

      @comic3 = FactoryBot.create(:comic, count_of_issues: 2)
      issue5 = FactoryBot.create(:issue, comic: @comic3)
      issue6 = FactoryBot.create(:issue, comic: @comic3)

      FactoryBot.create(:read_issue, user:, issue: issue1)
      FactoryBot.create(:read_issue, user:, issue: issue1) # Does not count this towards the progress of the comic

      FactoryBot.create(:read_issue, user:, issue: issue3, read_at: Time.current - 5.hours)
      FactoryBot.create(:read_issue, user:, issue: issue4, read_at: Time.current - 4.hours)

      FactoryBot.create(:read_issue, user:, issue: issue5, read_at: Time.current)
      FactoryBot.create(:read_issue, user:, issue: issue6, read_at: Time.current)
    end

    it "returns the users completed comics ordered by read at" do
      expect(user.completed_comics.to_a).to eq [@comic3, @comic2]
    end
  end

  describe "#incompleted_comics" do
    let(:user) { FactoryBot.create(:user) }

    before do
      @comic1 = FactoryBot.create(:comic, count_of_issues: 2)
      issue1 = FactoryBot.create(:issue, comic: @comic1)
      FactoryBot.create(:issue, comic: @comic1)

      @comic2 = FactoryBot.create(:comic, count_of_issues: 2)
      issue3 = FactoryBot.create(:issue, comic: @comic2)
      issue4 = FactoryBot.create(:issue, comic: @comic2)

      @comic3 = FactoryBot.create(:comic, count_of_issues: 2)
      issue5 = FactoryBot.create(:issue, comic: @comic3)
      FactoryBot.create(:issue, comic: @comic3)

      FactoryBot.create(:read_issue, user:, issue: issue1, read_at: Time.current - 5.hours)
      FactoryBot.create(:read_issue, user:, issue: issue1, read_at: Time.current - 4.hours) # Does not count this towards the progress of the comic

      FactoryBot.create(:read_issue, user:, issue: issue3)
      FactoryBot.create(:read_issue, user:, issue: issue4)

      FactoryBot.create(:read_issue, user:, issue: issue5, read_at: Time.current)
    end

    it "returns the users completed comics" do
      expect(user.incompleted_comics.to_a).to eq [@comic3, @comic1]
    end
  end

  describe ".search" do
    it "searches by user" do
      user_1 = FactoryBot.create(:user, username: "obi1")
      FactoryBot.create(:user, username: "anak1n")
      results = User.search(query: "obi")
      expect(results).to eq [user_1]
    end

    context "when query contains capital letters" do
      it "converts it to downcase" do
        user = FactoryBot.create(:user, username: "obi1")
        results = User.search(query: "Obi1")
        expect(results).to eq [user]
      end
    end
  end
end
