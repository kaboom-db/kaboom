class DashboardController < ApplicationController
  before_action :user_required

  def index
    @header = "Dashboard"

    @issue_history = current_user.read_issues.order(read_at: :desc).limit(6)
  end
end
