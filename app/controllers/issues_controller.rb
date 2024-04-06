class IssuesController < ApplicationController
  include VisitConcerns

  before_action :set_comic
  before_action :set_issue, except: %i[index]
  before_action :user_required, except: %i[index show]
  before_action :issue_required, except: %i[index]

  def index
    redirect_to comic_path(@comic)
  end

  def show
    set_resource_metadata(resource: @issue)
    add_visit(user: current_user, visited: @issue)

    @chart_data = Charts::ResourceTrendChart.new(resource: @issue, num_of_elms: 14, type: Charts::Constants::LINE, range_type: Charts::FrequencyChartGenerator::DAY).generate
  end

  def edit
  end

  def update
    if @issue.update(issue_params)
      redirect_to comic_issue_path(@issue, comic_id: @comic), notice: "#{@issue.name} was successfully updated."
    else
      render :edit
    end
  end

  def read
    read_issue = ReadIssue.new(read_at: params[:read_at] || Time.current, user: current_user, issue: @issue)

    if read_issue.save
      set_json_values(
        success: true,
        message: "You read #{@comic.name} - #{@issue.name}.",
        has_read: true,
        read_count:
      )
      return render template: "shared/read", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully marked this issue as read."
    else
      set_json_values(
        success: false,
        message: "Could not mark #{@comic.name} - #{@issue.name} as read.",
        has_read:,
        read_count:
      )
      return render template: "shared/read", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "Could not mark that issue as read."
    end
  end

  def unread
    read_issue = current_user.read_issues.find_by(id: params[:read_id], issue: @issue)
    return redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "You have not read this issue." unless read_issue.present?

    read_issue.destroy

    set_json_values(
      success: true,
      message: "You unread #{@comic.name} - #{@issue.name}.",
      has_read:,
      read_count:
    )
    return render template: "shared/read", formats: :json if request.xhr?

    redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully unmarked this issue."
  end

  def collect
    collected_issue = CollectedIssue.new(collected_on: params[:collected_on] || Date.today, user: current_user, issue: @issue)

    if collected_issue.save
      @success = true
      @message = "You collected #{@comic.name} - #{@issue.name}."
      @has_collected = true
      return render template: "shared/collected", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully collected this issue."
    else
      @success = false
      @message = "Could not collect #{@comic.name} - #{@issue.name}."
      @has_collected = current_user.collection.include?(@issue)
      return render template: "shared/collected", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "Could not collect this issue."
    end
  end

  def uncollect
    collected = current_user.collected_issues.find_by(issue: @issue)
    return redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "You have not collected this issue." unless collected.present?

    collected.destroy

    @success = true
    @message = "You uncollected #{@comic.name} - #{@issue.name}."
    @has_collected = false
    return render template: "shared/collected", formats: :json if request.xhr?

    redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully uncollected this issue."
  end

  def wishlist
    wishlisted = WishlistItem.new(wishlistable: @issue, user: current_user)

    if wishlisted.save
      @success = true
      @message = "You wishlisted #{@comic.name} - #{@issue.name}."
      @wishlisted = true
      return render template: "shared/wishlist", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully wishlisted this issue."
    else
      @success = false
      @message = "Could not wishlist #{@comic.name} - #{@issue.name}."
      @wishlisted = current_user.wishlisted_issues.include?(@issue)
      return render template: "shared/wishlist", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "Could not wishlist this issue."
    end
  end

  def unwishlist
    wishlisted = current_user.wishlist_items.find_by(wishlistable: @issue)
    return redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "You have not wishlisted this issue." unless wishlisted.present?

    wishlisted.destroy

    @success = true
    @message = "You unwishlisted #{@comic.name} - #{@issue.name}."
    @wishlisted = false
    return render template: "shared/wishlist", formats: :json if request.xhr?

    redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully unwishlisted this issue."
  end

  def favourite
    favourited = FavouriteItem.new(favouritable: @issue, user: current_user)

    if favourited.save
      @success = true
      @message = "You favourited #{@comic.name} - #{@issue.name}."
      @favourited = true
      return render template: "shared/favourite", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully favourited this issue."
    else
      @success = false
      @message = "Could not favourite #{@comic.name} - #{@issue.name}."
      @favourited = current_user.favourited_issues.include?(@issue)
      return render template: "shared/favourite", formats: :json if request.xhr?

      redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "Could not favourite this issue."
    end
  end

  def unfavourite
    favourited = current_user.favourite_items.find_by(favouritable: @issue)
    return redirect_to comic_issue_path(@issue, comic_id: @comic.id), alert: "You have not favourited this issue." unless favourited.present?

    favourited.destroy

    @success = true
    @message = "You unfavourited #{@comic.name} - #{@issue.name}."
    @favourited = false
    return render template: "shared/favourite", formats: :json if request.xhr?

    redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "Successfully unfavourited this issue."
  end

  def refresh
    ImportWorker.perform_async("Issue", @issue.cv_id)
    redirect_to comic_issue_path(@issue, comic_id: @comic.id), notice: "This issue will be refreshed soon."
  end

  private

  def issue_params
    params.require(:issue).permit(:rating, :cover_price, :currency_id, :page_count, :isbn, :upc)
  end

  def has_read
    current_user.issues_read.include?(@issue)
  end

  def read_count
    current_user.read_issues.where(issue: @issue).count
  end

  def issue_required
    redirect_to comic_path(@comic), alert: "Could not find that issue." unless @issue.present?
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
    @issue = @comic.issues.find_by(absolute_number: params[:id])
  end
end
