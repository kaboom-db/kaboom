class UsersController < ApplicationController
  before_action :set_user
  before_action :set_followers, except: %i[follow unfollow load_more_followers load_more_following edit update]
  before_action :set_following, except: %i[follow unfollow load_more_followers load_more_following edit update]
  before_action :authorise_user, only: %i[edit update]
  before_action :user_required, only: %i[follow unfollow]
  before_action :check_private, except: %i[edit update]

  FOLLOWS_PER_PAGE = 20

  def show
    set_metadata(title: "#{@user}'s Profile", description: "#{@user} is tracking their favourite comics on Kaboom. Check out their profile!")

    @history = @user.read_issues.order(read_at: :desc).limit(4)
    @deck = @user.incompleted_comics.take(4)
    @favourite_comics = @user.favourited_comics.limit(4)
    @completed_comics = @user.completed_comics.take(4)
    @collection = @user.collected_issues.order(collected_on: :desc).limit(4)
    @wishlisted = @user.wishlisted_comics.limit(4)

    @page = 1
    @activities = get_activities
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to edit_user_path(@user), notice: "Your profile has been successfully updated."
    else
      redirect_to edit_user_path(@user), alert: "We encountered an error whilst updating your account. Please try again later."
    end
  end

  # TODO: Extract to own class
  def history
    set_metadata(title: "#{@user}'s History", description: "Check out what comics #{@user} is reading on Kaboom!")

    @issue_history = @user.read_issues
      .order(read_at: :desc)
      .where(build_filters)
      .paginate(page: params[:page], per_page: 30)

    @issue_history_grouped = @issue_history.group_by { _1.read_at.strftime("%-d %b %Y") }
  end

  def deck
    set_metadata(title: "#{@user}'s Deck", description: "Check out what comics #{@user} is reading on Kaboom!")

    @deck = @user.incompleted_comics
      .paginate(page: params[:page], per_page: 30)
  end

  def favourites
    set_metadata(title: "#{@user}'s Favourites", description: "Check out #{@user}'s favourite comics on Kaboom!")

    @favourites = @user.favourite_items
      .paginate(page: params[:page], per_page: 30)
  end

  def completed
    set_metadata(title: "#{@user}'s Completed Comics", description: "Check out what comics #{@user} has read on Kaboom!")

    @completed = @user.completed_comics
      .paginate(page: params[:page], per_page: 30)
  end

  def collection
    set_metadata(title: "#{@user}'s Comic Collection", description: "Check out #{@user}'s comic collection. Pretty neat!")

    @collection = @user.collected_issues
      .order(collected_on: :desc)
      .paginate(page: params[:page], per_page: 30)

    @collection_grouped = @collection.group_by { _1.collected_on.strftime("%-d %b %Y") }
  end

  def wishlist
    set_metadata(title: "#{@user}'s Wishlist", description: "Check out what comics #{@user} wants to read on Kaboom!")

    @wishlist = @user.wishlist_items
      .paginate(page: params[:page], per_page: 30)
  end

  def follow
    follow_manager = Social::FollowManager.new(target: @user, follower: current_user)

    if follow_manager.follow
      redirect_to user_path(@user)
    else
      redirect_to user_path(@user), alert: "Could not follow #{@user}."
    end
  end

  def unfollow
    follow_manager = Social::FollowManager.new(target: @user, follower: current_user)

    if follow_manager.unfollow
      redirect_to user_path(@user)
    else
      redirect_to user_path(@user), alert: "Could not unfollow #{@user}."
    end
  end

  def load_more_activities
    @page = (params[:page] || 1).to_i
    @activities = get_activities
    respond_to do |format|
      format.html { not_found }
      format.turbo_stream
    end
  end

  def load_more_followers
    @followers_page = (params[:page] || 1).to_i
    @followers = get_followers
    respond_to do |format|
      format.html { not_found }
      format.turbo_stream
    end
  end

  def load_more_following
    @following_page = (params[:page] || 1).to_i
    @following = get_following
    respond_to do |format|
      format.html { not_found }
      format.turbo_stream
    end
  end

  private

  def get_activities
    Social::Feed.new(activities_by: @user, page: @page).generate
  end

  def get_followers
    @user.followers.paginate(page: @followers_page, per_page: FOLLOWS_PER_PAGE)
  end

  def get_following
    @user.following.paginate(page: @following_page, per_page: FOLLOWS_PER_PAGE)
  end

  def user_params
    params.require(:user).permit(:bio, :private, :show_nsfw, :allow_email_notifications, :currency_id)
  end

  def build_filters
    filters = {}
    filters[:issue] = params[:issue] if params[:issue].present?
    filters
  end

  def set_user
    @user = User.where.not(confirmed_at: nil).find_by!(username: params[:id])
  end

  def set_followers
    @followers_page = 1
    @followers = get_followers
  end

  def set_following
    @following_page = 1
    @following = get_following
  end

  def authorise_user
    redirect_back fallback_location: root_path, alert: "You are not authorised to access this page." unless @user == current_user
  end

  def check_private
    render "private_user" if @user != current_user && @user.private?
  end
end
