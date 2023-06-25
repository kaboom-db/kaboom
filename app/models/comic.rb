class Comic < ApplicationRecord
  # associations
  has_many :issues
  has_many :ordered_issues, -> { order(issue_number: :asc) }, class_name: "Issue"

  # validations
  validates :cv_id, :name, presence: true
  validates :cv_id, uniqueness: true

  def aliases_to_array
    return [] unless aliases.present?

    aliases.split("\n").select { _1.present? }
  end

  def import_issues
    results = ComicVine::VolumeIssues.new(volume_id: cv_id, count_of_issues:).retrieve
    results.each do |r|
      issue = issues.find_or_initialize_by(cv_id: r[:id])
      issue.update(
        aliases: r[:aliases],
        api_detail_url: r[:api_detail_url],
        cover_date: r[:cover_date],
        date_last_updated: r[:date_last_updated],
        deck: r[:deck],
        description: r[:description],
        image: r[:image][:medium_url],
        issue_number: r[:issue_number].gsub(" + ", "."),
        name: r[:name] || "Issue ##{r[:issue_number]}",
        site_detail_url: r[:site_detail_url],
        store_date: r[:store_date]
      )
    end
  end

  def sync
    result = ComicVine::Volume.new(id: cv_id).retrieve
    return unless result.present?

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

  def self.import(comic_vine_id:)
    comic = Comic.find_or_initialize_by(cv_id: comic_vine_id)
    comic.sync
    comic
  end

  def self.search(query:)
    where("lower(name) LIKE ?", "%#{query.downcase}%").or(where("lower(aliases) LIKE ?", "%#{query.downcase}%"))
  end
end
