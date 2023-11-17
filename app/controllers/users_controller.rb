class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def show
  end

  private

  def set_user
    @user = User.where.not(confirmed_at: nil).find_by!(username: params[:id])
  end
end
