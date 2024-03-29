# frozen_string_literal: true

class ResourceTileControlComponent < ViewComponent::Base
  def initialize(issue:, user:)
    @issue = issue
    @comic = issue.comic
    @user = user
    @read_at = user&.read_issues&.order(read_at: :desc)&.where(issue:)&.first&.read_at
  end
end
