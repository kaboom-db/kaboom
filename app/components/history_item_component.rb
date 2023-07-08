# frozen_string_literal: true

class HistoryItemComponent < ViewComponent::Base
  def initialize(issue:, user:)
    @issue = issue
    @comic = issue.comic
    @user = user

    @is_read = user.issues_read.include?(issue)
  end
end
