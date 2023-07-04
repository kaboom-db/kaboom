class Issue < ApplicationRecord
  # associations
  belongs_to :comic
  has_many :visits, as: :visited

  # validations
  validates :name, :issue_number, presence: true
  validates :issue_number, uniqueness: {scope: :comic_id}

  # scopes
  # TODO: Add spec
  scope :trending, -> {
    select("issues.*, COUNT(visits.id) AS visit_count").joins(:visits).group("issues.id").order("visit_count DESC").limit(5)
  }

  def formatted_issue_number
    issue_number.to_s.gsub(/\.0\b/, "")
  end

  def to_param = formatted_issue_number.tr(".", "_")
end
