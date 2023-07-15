class IssuesController < ApplicationController
  include VisitConcerns

  before_action :set_comic
  before_action :set_issue, only: %i[show read unread wishlist]
  before_action :user_required, only: %i[read unread wishlist]

  def index
  end

  def show
    return redirect_to comic_path(@comic), notice: "Could not find that issue." unless @issue.present?

    add_visit(user: current_user, visited: @issue)
  end

  def read
    return redirect_to comic_path(@comic), alert: "Could not find that issue." unless @issue.present?

    read_issue = ReadIssue.new(read_at: params[:read_at] || Time.current, user: current_user, issue: @issue)

    if read_issue.save
      set_json_values(
        success: true,
        message: "You read #{@comic.name} - #{@issue.name}.",
        has_read: true,
        read_count:
      )
      return render template: "issues/read", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully marked this issue as read."
    else
      set_json_values(
        success: false,
        message: "Could not mark #{@comic.name} - #{@issue.name} as read.",
        has_read:,
        read_count:
      )
      return render template: "issues/read", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "Could not mark that issue as read."
    end
  end

  def unread
    return redirect_to comic_path(@comic), alert: "Could not find that issue." unless @issue.present?

    read_issue = ReadIssue.find_by(id: params[:read_id], issue: @issue)
    return redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "You have not read this issue." unless read_issue.present?
    return redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "You are not authorised to do that." unless read_issue.user == current_user

    read_issue.destroy

    set_json_values(
      success: true,
      message: "You unread #{@comic.name} - #{@issue.name}.",
      has_read:,
      read_count:
    )
    return render template: "issues/read", formats: :json if request.xhr?

    redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully unmarked this issue."
  end

  def wishlist
    return redirect_to comic_path(@comic), alert: "Could not find that issue." unless @issue.present?

    wishlisted = WishlistItem.new(wishlistable: @issue, user: current_user)

    if wishlisted.save
      @success = true
      @message = "You wishlisted #{@comic.name} - #{@issue.name}."
      @wishlisted = current_user.wishlisted_issues.include?(@issue)
      return render template: "issues/wishlist", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully wishlisted this issue."
    else
      @success = false
      @message = "Could not wishlist #{@comic.name} - #{@issue.name}."
      @wishlisted = current_user.wishlisted_issues.include?(@issue)
      return render template: "issues/wishlist", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "Could not wishlist this issue."
    end
  end

  private

  def has_read
    current_user.issues_read.include?(@issue)
  end

  def read_count
    current_user.read_issues.where(issue: @issue).count
  end

  def set_json_values(success:, message:, has_read:, read_count:)
    @success = success
    @message = message
    @has_read = has_read
    @read_count = read_count
  end

  def set_comic
    @comic = Comic.find(params[:comic_id])
  end

  def set_issue
    @issue = @comic.issues.find_by(issue_number: params[:id].tr("_", ".").to_f)
  end
end
