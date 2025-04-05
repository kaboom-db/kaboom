class WishlistItemsController < ApplicationController
  before_action :set_wishlist_item
  before_action :authorize_user
  before_action :validate_params

  def move
    @wishlist_item.insert_at(params[:position].to_i)
    head :ok
  end

  private

  def validate_params
    head :bad_request unless params[:position].present?
  end

  def authorize_user
    head :unauthorized unless current_user == @wishlist_item.user
  end

  def set_wishlist_item
    @wishlist_item = WishlistItem.find(params[:id])
  end
end
