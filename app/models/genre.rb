class Genre < ApplicationRecord
  # Associations
  has_and_belongs_to_many :comics

  def to_s = name

  def to_param = name.downcase
end
