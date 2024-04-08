module Social
  # `record` is a Follow
  class FollowedActivity < Activity
    def content = "#{user} started following #{record.target}"

    def link = user_path(record.target)

    def timestamp = record.created_at

    def image = record.target.avatar

    def user = @user ||= record.follower
  end
end
