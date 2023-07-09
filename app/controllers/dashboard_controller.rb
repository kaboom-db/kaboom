class DashboardController < ApplicationController
  before_action :user_required

  def index
    @header = "Dashboard"

    @issue_history = current_user.read_issues.order(read_at: :desc).limit(6)
  end

  def history
    @header = "Your history"

    @issue_history = current_user.read_issues.order(read_at: :desc)
    if params[:issue]
      @issue_history = @issue_history.where(issue: params[:issue])
    end
  end
end
