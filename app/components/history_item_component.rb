# frozen_string_literal: true

class HistoryItemComponent < ViewComponent::Base
  def initialize(read_issue:)
    @read_issue = read_issue
    @issue = read_issue.issue
    @comic = read_issue.comic
  end
end
