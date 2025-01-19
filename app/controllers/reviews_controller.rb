class ReviewsController < ApplicationController
  before_action :set_review, except: [:new, :create]
  before_action :user_required, except: [:show]
  before_action :validate_user, only: [:edit, :update, :destroy]
  before_action :validate_type, only: [:new, :update, :create]

  def show
  end

  def edit
  end

  def new
    @reviewable = reviewable
    return redirect_back fallback_location: root_path unless @reviewable
    @review = Review.find_or_initialize_by(user: current_user, reviewable: @reviewable)
  end

  def create
    @reviewable = reviewable
    return redirect_back fallback_location: root_path unless @reviewable
    @review = Review.new(user: current_user, reviewable: @reviewable)

    if @review.update(review_params)
      redirect_to review_path(@review), notice: "Review submitted."
    else
      render :new
    end
  end

  def update
    if @review.update(review_params)
      redirect_to review_path(@review), notice: "Review updated."
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to polymorphic_path([@review.reviewable.respond_to?(:comic) ? @review.reviewable.comic : nil, @review.reviewable]), notice: "Review has been deleted."
  end

  private

  def review_params
    params.require(:review).permit(:title, :content)
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def validate_user
    if @review.user != current_user
      not_found
    end
  end

  def validate_type
    unless Review::REVIEWABLE_TYPES.include?(reviewable_type)
      redirect_back fallback_location: root_path, alert: "Invalid reviewable_type"
    end
  end

  def reviewable
    # Reviewable type should be validated by this point
    klass = reviewable_type.classify.constantize
    klass.find(reviewable_id)
  rescue
    nil
  end

  def reviewable_type = params["review"].present? ? params["review"]["reviewable_type"] : params["reviewable_type"]

  def reviewable_id = params["review"].present? ? params["review"]["reviewable_id"] : params["reviewable_id"]
end
