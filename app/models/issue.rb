class Issue < ApplicationRecord
  # associations
  belongs_to :comic
  belongs_to :currency, optional: true
  has_many :visits, as: :visited, dependent: :delete_all
  has_many :read_issues, dependent: :delete_all
  has_many :collected_issues, dependent: :delete_all

  # validations
  validates :name, :issue_number, :absolute_number, presence: true
  validates :issue_number, uniqueness: {scope: :comic_id}
  validates :isbn, isbn_format: true, allow_nil: true, allow_blank: true

  # scopes
  scope :trending, -> {
    select("issues.*, COUNT(visits.id) AS visit_count")
      .joins(:visits, :comic)
      .where(visits: {created_at: (Time.current - 24.hours)..Time.current}, comic: {nsfw: false})
      .group("issues.id")
      .order("visit_count DESC")
  }
  scope :safe_for_work, -> { joins(:comic).where(comic: {nsfw: false}) }

  def year = store_date&.year

  def formatted_issue_number
    issue_number.to_s.gsub(/\.0\b/, "")
  end

  def to_param = absolute_number

  def next = comic.issues.find_by(absolute_number: absolute_number + 1)
end
