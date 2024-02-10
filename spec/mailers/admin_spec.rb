require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "#notify_missing_issues" do
    let(:comic) { FactoryBot.create(:comic, name: "Test Comic", count_of_issues: 100) }

    it "sends an email to the admin" do
      email = AdminMailer.notify_missing_issues(
        comic:, failed: ["1", "2"]
      )
      assert_emails 1 do
        email.deliver_now
      end

      assert_equal ["hello@kaboom.rocks"], email.from
      assert_equal ["hello@kaboom.rocks"], email.to
      assert_equal "Test Comic has an incorrect amount of issues.", email.subject
      expect(email.body).to include(comic_url(comic))
      expect(email.body).to include("Test Comic is missing some issues. ComicVine has 100 issues but only 0 were imported. Missing issue numbers are: 1, 2.")
      expect(email.body).to include("There are some missing issues")
    end
  end
end
