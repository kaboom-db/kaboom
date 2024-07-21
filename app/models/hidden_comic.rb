class HiddenComic < ApplicationRecord
  # Assocations
  belongs_to :comic
  belongs_to :user

  # Validations
  validates :user_id, uniqueness: {scope: :comic_id}
end
