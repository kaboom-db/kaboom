class Comic < ApplicationRecord
  TYPES = [
    TRADE_PAPERBACK = "Trade Paperback",
    GRAPHIC_NOVEL = "Graphic Novel",
    MANGA = "Manga",
    MANHWA = "Manhwa",
    COMPLETE = "Completed Series",
    ONGOING_SERIES = "Ongoing Series",
    ONESHOT = "Oneshot",
    HARDCOVER = "Hardcover",
    ANNUAL_SERIES = "Annual Series",
    SPECIAL = "Special Series"
  ]

  # associations
  has_many :issues
  has_many :ordered_issues, -> { order(absolute_number: :asc) }, class_name: "Issue"
  has_many :read_issues, through: :issues
  has_many :visits, as: :visited, dependent: :delete_all
  belongs_to :country, optional: true
  has_and_belongs_to_many :genres

  # validations
  validates :cv_id, :name, presence: true
  validates :cv_id, uniqueness: true
  validates_inclusion_of :comic_type, in: TYPES, allow_nil: true, allow_blank: true

  # scopes
  scope :trending, -> {
    select("comics.*, COUNT(visits.id) AS visit_count")
      .joins(:visits)
      .where(visits: {created_at: (Time.current - 24.hours)..Time.current}, nsfw: false)
      .group("comics.id")
      .order("visit_count DESC")
  }
  scope :safe_for_work, -> { where(nsfw: false) }

  def aliases_to_array
    return [] unless aliases.present?

    aliases.split("\n").select { _1.present? }
  end

  def import_issues
    results = ComicVine::VolumeIssues.new(volume_id: cv_id, count_of_issues:).retrieve
    failed = []
    results.each.with_index(1) do |r, index|
      issue = issues.find_or_initialize_by(cv_id: r[:id])
      success = issue.update(
        aliases: r[:aliases],
        api_detail_url: r[:api_detail_url],
        cover_date: r[:cover_date],
        date_last_updated: r[:date_last_updated],
        deck: r[:deck],
        description: r[:description],
        image: r[:image][:medium_url],
        issue_number: r[:issue_number],
        name: r[:name] || "Issue ##{r[:issue_number]}",
        site_detail_url: r[:site_detail_url],
        store_date: r[:store_date],
        absolute_number: index
      )
      failed << r[:issue_number] unless success
    end
    AdminMailer.notify_missing_issues(comic: self, failed:).deliver_later unless failed.empty?
  end

  def sync
    result = ComicVine::Volume.new(id: cv_id).retrieve
    return unless result.present? && result[:error] == "OK"

    volume = result[:results]
    aliases = volume[:aliases]
    api_detail_url = volume[:api_detail_url]
    count_of_issues = volume[:count_of_issues]
    date_last_updated = volume[:date_last_updated]
    deck = volume[:deck]
    description = volume[:description]
    image = volume[:image][:medium_url]
    name = volume[:name]
    publisher = volume[:publisher][:name]
    site_detail_url = volume[:site_detail_url]
    start_year = volume[:start_year]

    update(
      aliases:,
      api_detail_url:,
      count_of_issues:,
      date_last_updated:,
      deck:,
      description:,
      image:,
      name:,
      publisher:,
      site_detail_url:,
      start_year:
    )
  end

  def year = start_year

  def to_s = name

  def self.import(comic_vine_id:, nsfw: false)
    comic = Comic.find_or_initialize_by(cv_id: comic_vine_id)
    comic.nsfw = nsfw
    comic.sync
    comic
  end

  def self.trending_for(genre)
    Comic.trending.joins(:genres).where(genres: genre)
  end

  def self.search(query:, nsfw: false)
    words = query.split(" ")
    results = Comic
    words.each { |word| results = results.where(["lower(name) LIKE ? OR lower(aliases) LIKE ?", "%#{word}%", "%#{word}%"]) }
    nsfw_filter = nsfw ? {} : {nsfw: false}
    results.where(nsfw_filter)
  end
end
