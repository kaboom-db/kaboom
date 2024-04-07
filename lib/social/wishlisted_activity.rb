module Social
  # `record` is a WishlistItem
  class WishlistedActivity < Activity
    def content = "#{user} wishlisted #{record.wishlistable.name}"

    def link
      if record.wishlistable.is_a?(Issue)
        comic_issue_path(record.wishlistable, comic_id: record.wishlistable.comic)
      else
        comic_path(record.wishlistable)
      end
    end

    def timestamp = record.created_at

    def image = record.wishlistable.image
  end
end
