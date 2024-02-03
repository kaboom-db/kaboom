class Currency < ApplicationRecord
  # Associations
  has_many :issues, dependent: :nullify

  # Validations
  validates :symbol, :symbol_native, :name, :code, presence: true
  validates :code, uniqueness: true

  def to_s = name
end
