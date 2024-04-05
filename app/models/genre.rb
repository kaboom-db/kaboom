class Genre < ApplicationRecord
  # Associations
  has_and_belongs_to_many :comics

  # Validations
  validates_presence_of :fa_icon, :name

  def to_s = name

  def to_param = name.downcase
end
