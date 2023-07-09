class IssuesController < ApplicationController
  include VisitConcerns

  before_action :set_comic
  before_action :set_issue, only: %i[show read]
  before_action :user_required, only: %i[read]

  def index
  end

  def show
    return redirect_to comic_path(@comic), notice: "Could not find that issue." unless @issue.present?

    add_visit(user: current_user, visited: @issue)
  end

  def read
    unless @issue.present?
      @success = false
      @message = "Could not find that issue."
      @has_read = false
      return render template: "issues/read", formats: :json if request.xhr?

      return redirect_to comic_path(@comic), alert: "Could not find that issue."
    end

    read_issue = ReadIssue.new(read_at: params[:read_at] || Time.current, user: current_user, issue: @issue)

    if read_issue.save
      @success = true
      @message = "You read #{@comic.name} - #{@issue.name}."
      @has_read = true
      return render template: "issues/read", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully marked this issue as read."
    else
      @success = false
      @message = "Could not mark #{@comic.name} - #{@issue.name} as read."
      @has_read = current_user.issues_read.include?(@issue)
      return render template: "issues/read", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "Could not mark that issue as read."
    end
  end

  private

  def set_comic
    @comic = Comic.find(params[:comic_id])
  end

  def set_issue
    @issue = @comic.issues.find_by(issue_number: params[:id].tr("_", ".").to_f)
  end
end
