class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def show
    @history = @user.read_issues.order(read_at: :desc).limit(6)
    @deck = @user.incompleted_comics.take(6)
    @favourite_comics = @user.favourited_comics.limit(6)
    @completed_comics = @user.completed_comics.take(12)
    @wishlisted = @user.wishlisted_comics.limit(12)
  end

  private

  def set_user
    @user = User.where.not(confirmed_at: nil).find_by!(username: params[:id])
  end
end
