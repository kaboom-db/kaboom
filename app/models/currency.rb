class Currency < ApplicationRecord
  # Validations
  validates :symbol, :symbol_native, :name, presence: true
end
