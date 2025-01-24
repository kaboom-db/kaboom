class Review < ApplicationRecord
  REVIEWABLE_TYPES = [
    "Comic",
    "Issue"
  ]

  # Associations
  belongs_to :user
  belongs_to :reviewable, polymorphic: true

  # Validations
  validates :user_id, uniqueness: {scope: [:reviewable_id, :reviewable_type]}
  validates :title, :content, presence: true
  validates_inclusion_of :reviewable_type, in: REVIEWABLE_TYPES, allow_nil: false, allow_blank: false

  def score
    return @score if @score

    @score ||= user.ratings.find_by(rateable: reviewable)&.score || 0
  end

  def tier
    return nil if score == 0

    tier = ((score * 10) / (100.0 / 3)).floor
    [tier, 2].min
  end
end
