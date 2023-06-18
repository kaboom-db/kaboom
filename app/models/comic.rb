class Comic < ApplicationRecord
  # TODO: Needs specs with webmock
  def self.import(comic_vine_id:)
    result = ComicVine::Volume.new(id: comic_vine_id).retrieve
    raise("There was an error importing this comic from ComicVine.") unless result.present?

    volume = result[:results]
    aliases = volume[:aliases]
    api_detail_url = volume[:api_detail_url]
    count_of_issues = volume[:count_of_issues]
    date_last_updated = volume[:date_last_updated]
    deck = volume[:deck]
    description = volume[:description]
    cv_id = volume[:id]
    image = volume[:image][:medium_url]
    name = volume[:name]
    publisher = volume[:publisher][:name]
    site_detail_url = volume[:site_detail_url]
    start_year = volume[:start_year].to_i

    comic = Comic.find_or_initialize_by(cv_id:)
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
