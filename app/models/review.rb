class Review < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :reviewable, polymorphic: true

  # Validations
  validates :user_id, uniqueness: {scope: [:reviewable_id, :reviewable_type]}

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
