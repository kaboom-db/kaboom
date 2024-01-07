class UsersController < ApplicationController
  before_action :set_user, only: %i[show history deck favourites completed collection wishlist]

  def show
    @history = @user.read_issues.order(read_at: :desc).limit(6)
    @deck = @user.incompleted_comics.take(6)
    @favourite_comics = @user.favourited_comics.limit(6)
    @completed_comics = @user.completed_comics.take(12)
    @collection = @user.collected_issues.order(collected_on: :desc).limit(12)
    @wishlisted = @user.wishlisted_comics.limit(12)
  end

  # TODO: Extract to own class
  # TODO: Add tests for each list
  def history
    @issue_history = @user.read_issues
      .order(read_at: :desc)
      .where(build_filters)
      .page(params[:page])
      .per(30)

    @issue_history_grouped = @issue_history.group_by { _1.read_at.strftime("%-d %b %Y") }
  end

  def deck
    @deck = @user.incompleted_comics
      .page(params[:page])
      .per(30)
  end

  def favourites
    @favourites = @user.favourite_items
      .page(params[:page])
      .per(30)
  end

  def completed
    @completed = @user.completed_comics
      .page(params[:page])
      .per(30)
  end

  def collection
    @collection = current_user.collected_issues
      .order(collected_on: :desc)
      .page(params[:page])
      .per(30)

    @collection_grouped = @collection.group_by { _1.collected_on.strftime("%-d %b %Y") }
  end

  def wishlist
    @wishlist = @user.wishlist_items
      .page(params[:page])
      .per(30)
  end

  private

  def build_filters
    filters = {}
    filters[:issue] = params[:issue] if params[:issue].present?
    filters
  end

  def set_user
    @user = User.where.not(confirmed_at: nil).find_by!(username: params[:id])
  end
end
