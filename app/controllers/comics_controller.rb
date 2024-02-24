class ComicsController < ApplicationController
  include VisitConcerns

  before_action :set_comic, only: %i[show edit update wishlist unwishlist favourite unfavourite read_range refresh read_next_issue]
  before_action :user_required, only: %i[edit update import wishlist unwishlist favourite unfavourite read_range refresh read_next_issue]

  def index
    set_metadata(title: "Comics", description: "Track your comic reading habits. Discover new issues and add to your ever growing pull list!")

    @header = "📚 Comics"
    if params[:search]
      @search = params[:search]
      @search_results = Comic.search(query: @search)
    end
    @recently_updated = Comic.order(updated_at: :desc).limit(6)
    @trending = Comic.trending.limit(5)
    @recently_updated_issues = Issue.order(updated_at: :desc).limit(6)
    @trending_issues = Issue.trending.limit(5)
  end

  def show
    set_resource_metadata(resource: @comic)
    add_visit(user: current_user, visited: @comic)

    @ordered_issues = @comic.ordered_issues
      .page(params[:page])
      .per(30)

    @chart_data = Charts::ResourceTrendChart.new(resource: @comic, num_of_elms: 14, type: Charts::ChartCountGenerator::LINE, range_type: Charts::FrequencyChartGenerator::DAY).generate
  end

  def edit
  end

  def update
    if @comic.update(comic_params)
      redirect_to comic_path(@comic), notice: "#{@comic.name} was successfully updated."
    else
      render :edit
    end
  end

  def import
    @comic = Comic.import(comic_vine_id: params[:comicvine_id])
    unless @comic.persisted?
      return redirect_to comics_path, alert: "There was an error importing this comic."
    end

    @comic.import_issues

    redirect_to comic_path(@comic), notice: "#{@comic.name} was successfully imported."
  end

  def wishlist
    wishlisted = WishlistItem.new(wishlistable: @comic, user: current_user)

    if wishlisted.save
      @success = true
      @message = "You wishlisted #{@comic.name}."
      @wishlisted = true
      return render template: "shared/wishlist", formats: :json if request.xhr?

      redirect_to comic_path(@comic), notice: "Successfully wishlisted this comic."
    else
      @success = false
      @message = "Could not wishlist #{@comic.name}."
      @wishlisted = current_user.wishlisted_comics.include?(@comic)
      return render template: "shared/wishlist", formats: :json if request.xhr?

      redirect_to comic_path(@comic), alert: "Could not wishlist this comic."
    end
  end

  def unwishlist
    wishlisted = current_user.wishlist_items.find_by(wishlistable: @comic)
    return redirect_to comic_path(@comic), alert: "You have not wishlisted this comic." unless wishlisted.present?

    wishlisted.destroy

    @success = true
    @message = "You unwishlisted #{@comic.name}."
    @wishlisted = false
    return render template: "shared/wishlist", formats: :json if request.xhr?

    redirect_to comic_path(@comic), notice: "Successfully unwishlisted this comic."
  end

  def favourite
    favourited = FavouriteItem.new(favouritable: @comic, user: current_user)

    if favourited.save
      @success = true
      @message = "You favourited #{@comic.name}."
      @favourited = true
      return render template: "shared/favourite", formats: :json if request.xhr?

      redirect_to comic_path(@comic), notice: "Successfully favourited this comic."
    else
      @success = false
      @message = "Could not favourite #{@comic.name}."
      @favourited = current_user.favourited_comics.include?(@comic)
      return render template: "shared/favourite", formats: :json if request.xhr?

      redirect_to comic_path(@comic), alert: "Could not favourite this comic."
    end
  end

  def unfavourite
    favourited = current_user.favourite_items.find_by(favouritable: @comic)
    return redirect_to comic_path(@comic), alert: "You have not favourited this comic." unless favourited.present?

    favourited.destroy

    @success = true
    @message = "You unfavourited #{@comic.name}."
    @favourited = false
    return render template: "shared/favourite", formats: :json if request.xhr?

    redirect_to comic_path(@comic), notice: "Successfully unfavourited this comic."
  end

  def read_range
    read_at = Time.current
    # These are actually indexes of the comic.issues array
    first_issue = params[:start].to_i - 1
    last_issue = params[:end].to_i - 1

    # Set first_issue to 0 here - I don't expect people will try to abuse it with random numbers
    # but just being safe :)
    first_issue = 0 if first_issue < 0 || first_issue > last_issue
    last_issue = @comic.count_of_issues if last_issue > @comic.count_of_issues

    issues = @comic.ordered_issues[first_issue..last_issue]
    issues.each do |issue|
      ReadIssue.create(read_at:, user: current_user, issue:)
    end
    @message = "Successfully marked issues #{first_issue + 1}-#{last_issue + 1} as read"
    return render template: "shared/read_range", formats: :json if request.xhr?

    redirect_to comic_path(@comic), notice: @message
  end

  def refresh
    ImportWorker.perform_async("Comic", @comic.cv_id)
    redirect_to comic_path(@comic), notice: "This comic will be refreshed soon."
  end

  def read_next_issue
    issue = current_user.next_up_for(@comic)
    if issue.present?
      ReadIssue.create(read_at: Time.current, user: current_user, issue:)
    end
    render partial: "shared/user_progress_sidebar"
  end

  private

  def set_comic
    @comic = Comic.find(params[:id])
  end

  def comic_params
    params.require(:comic).permit(:nsfw, :comic_type, :country_id, genre_ids: [])
  end
end
