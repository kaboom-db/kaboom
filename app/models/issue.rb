class Issue < ApplicationRecord
  # associations
  belongs_to :comic
  belongs_to :currency, optional: true
  has_many :visits, as: :visited, dependent: :delete_all
  has_many :read_issues, dependent: :delete_all

  # validations
  validates :name, :issue_number, presence: true
  validates :issue_number, uniqueness: {scope: :comic_id}
  validates :isbn, isbn_format: true, allow_nil: true, allow_blank: true

  # scopes
  scope :trending, -> {
    select("issues.*, COUNT(visits.id) AS visit_count")
      .joins(:visits)
      .where(visits: {created_at: (Time.current - 24.hours)..Time.current})
      .group("issues.id")
      .order("visit_count DESC")
  }

  def year = store_date&.year

  def formatted_issue_number
    issue_number.to_s.gsub(/\.0\b/, "")
  end

  def to_param = formatted_issue_number.tr(".", "_")
end
