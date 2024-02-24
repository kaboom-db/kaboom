class Country < ApplicationRecord
  COLOURS = {
    en: "#D0142C",
    ja: "#BB002D",
    ko: "#0650AD"
  }

  # Associations
  has_many :comics, dependent: :nullify

  # Validations
  validates :name, :language_code, presence: true

  def to_s = name

  def colour = COLOURS[language_code.to_sym] || "#ff5f6d"
end
