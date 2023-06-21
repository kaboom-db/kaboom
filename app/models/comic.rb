class Comic < ApplicationRecord
  # TODO: Add spec
  def safe_description
    description.gsub(/<\/?(a|script|figure|img)[^>]*>/, "")
  end

  # TODO: Add spec
  def aliases_to_array
    return [] unless aliases.present?

    aliases.split("\n")
  end

  def self.import(comic_vine_id:)
    comic = Comic.find_or_initialize_by(cv_id: comic_vine_id)
    sync(comic:)
  end

  def self.sync(comic:)
    result = ComicVine::Volume.new(id: comic.cv_id).retrieve
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
    start_year = volume[:start_year].to_i

    comic.update(
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
end
