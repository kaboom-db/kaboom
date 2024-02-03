class Country < ApplicationRecord
  # Associations
  has_many :comics, dependent: :nullify

  # Validations
  validates :name, :language_code, presence: true

  def to_s = name
end
