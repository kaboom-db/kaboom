module Social
  # `record` is a Rating
  class RatedActivity < Activity
    def content = "#{user} rated #{record.rateable} a #{record.score}/10"

    def link
      if record.rateable.is_a?(Issue)
        comic_issue_path(record.rateable, comic_id: record.rateable.comic)
      else
        comic_path(record.rateable)
      end
    end

    def timestamp = record.updated_at

    def image = record.rateable.image
  end
end
