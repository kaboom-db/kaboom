class AdminMailer < ApplicationMailer
  EMAIL = "hello@kaboom.rocks"

  def notify_missing_issues(comic:, failed:)
    @header = "There are some missing issues"
    @comic = comic
    @failed = failed

    mail(to: EMAIL, subject: "#{comic} has an incorrect amount of issues.")
  end
end
