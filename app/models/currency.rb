class Currency < ApplicationRecord
  PLACEMENTS = [
    VALUE_START = "start",
    VALUE_END = "end"
  ]

  # Associations
  has_many :users, dependent: :nullify

  # Validations
  validates :symbol, :symbol_native, :name, :code, presence: true
  validates :code, uniqueness: true
  validates_inclusion_of :placement, in: PLACEMENTS, allow_nil: true, allow_blank: true

  # Callbacks
  after_initialize :set_defaults

  def to_s = name

  private

  def set_defaults
    self.placement ||= VALUE_START
  end
end
