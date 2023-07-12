# frozen_string_literal: true

class ResourceTileControlComponent < ViewComponent::Base
  def initialize(issue:, user:, read_at:)
    @issue = issue
    @comic = issue.comic
    @user = user
    @read_at = read_at
  end
end
