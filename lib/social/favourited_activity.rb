module Social
  # `record` is a FavouriteItem
  class FavouritedActivity < Activity
    def content = "#{user} favourited #{record.favouritable.name}"

    def link
      if record.favouritable.is_a?(Issue)
        comic_issue_path(record.favouritable, comic_id: record.favouritable.comic)
      else
        comic_path(record.favouritable)
      end
    end

    def timestamp = record.created_at

    def image = record.favouritable.image
  end
end
