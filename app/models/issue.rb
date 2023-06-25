class Issue < ApplicationRecord
  # associations
  belongs_to :comic

  def formatted_issue_number
    issue_number.to_s.gsub(/\.0\b/, "")
  end

  def to_param = formatted_issue_number.gsub(".", "_")
end
