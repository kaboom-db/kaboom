# frozen_string_literal: true

class HistoryItemComponent < ViewComponent::Base
  def initialize(issue:, user:)
    @issue = issue
    @comic = issue.comic
    @user = user
  end
end
