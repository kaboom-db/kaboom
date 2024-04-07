module Social
  class Feed
    attr_reader :user, :page

    PER_PAGE = 10

    def initialize(user:, page: 1)
      @user = user
      @page = page
    end

    def generate
      read_issues = get_activities_for(ReadIssue, {read_at: :desc}, {user: user.following}, [:issue, :comic, :user])
      collected_issues = get_activities_for(CollectedIssue, {collected_on: :desc}, {user: user.following}, [:issue, :comic, :user])
      wishlist_items = get_activities_for(WishlistItem, {created_at: :desc}, {user: user.following}, [:wishlistable, :user])
      favourite_items = get_activities_for(FavouriteItem, {created_at: :desc}, {user: user.following}, [:favouritable, :user])
      follows = get_activities_for(Follow, {created_at: :desc}, {follower: user.following}, [:follower, :target])
      activities = sort(read_issues + collected_issues + wishlist_items + favourite_items + follows)

      start_index = (page - 1) * PER_PAGE
      end_index = start_index + (PER_PAGE - 1)
      activities[start_index..end_index] || []
    end

    private

    def sort(activities)
      activities.sort_by { _1.timestamp }.reverse
    end

    def get_activities_for(klass, order, filter, includes)
      klass.includes(includes).order(order).where(filter).map { _1.social_class.new(record: _1) }
    end
  end
end
