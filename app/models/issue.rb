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

  def sync
    result = ComicVine::Issue.new(id: cv_id).retrieve
    return unless result.present? && result[:error] == "OK"

    issue = result[:results]

    update(
      aliases: issue[:aliases],
      api_detail_url: issue[:api_detail_url],
      cover_date: issue[:cover_date],
      date_last_updated: issue[:date_last_updated],
      deck: issue[:deck],
      description: issue[:description],
      image: issue[:image][:medium_url],
      issue_number: issue[:issue_number],
      name: issue[:name] || "Issue ##{issue[:issue_number]}",
      site_detail_url: issue[:site_detail_url],
      store_date: issue[:store_date]
    )
  end

  # For duck typing with Comic.import
  def self.import(comic_vine_id:)
    issue = Issue.find_by(cv_id: comic_vine_id)
    return unless issue.present?
    issue.sync
    issue
  end
end
