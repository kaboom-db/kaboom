class ComicsController < ApplicationController
  include VisitConcerns

  before_action :set_comic, only: %i[show wishlist unwishlist]
  before_action :user_required, only: %i[import wishlist unwishlist]

  def index
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
    add_visit(user: current_user, visited: @comic)
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

  private

  def set_comic
    @comic = Comic.find(params[:id])
  end
end
