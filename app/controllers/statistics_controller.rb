class StatisticsController < ApplicationController
  before_action :set_user
  before_action :set_year, only: [:show]

  def index
    set_counts(year: Statistics::BaseCount::ALLTIME)
  end

  def show
    set_counts
  end

  private

  def set_counts(year: nil)
    @read_counts, @collected_counts = Statistics::BaseCount.all_counts_for(year: year || @year, user: @user)
  end

  def set_user
    @user = User.where.not(confirmed_at: nil).find_by!(username: params[:user_id])
  end

  def set_year
    @year = params[:id]
    head :not_found unless @year == Statistics::BaseCount::ALLTIME || Date.new(@year.to_i).gregorian?
  end
end
