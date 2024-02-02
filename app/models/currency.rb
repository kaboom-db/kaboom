class Currency < ApplicationRecord
  # Associations
  has_many :issues, dependent: :nullify

  # Validations
  validates :symbol, :symbol_native, :name, :code, presence: true

  def to_s = name
end
