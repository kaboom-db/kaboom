class Issue < ApplicationRecord
  # associations
  belongs_to :comic

  # validations
  validates :name, :issue_number, presence: true
  validates :issue_number, uniqueness: {scope: :comic_id}

  def formatted_issue_number
    issue_number.to_s.gsub(/\.0\b/, "")
  end

  def to_param = formatted_issue_number.tr(".", "_")
end
