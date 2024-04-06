module Social
  class FollowManager
    attr_reader :target, :follower

    def initialize(target:, follower:)
      @target = target
      @follower = follower
    end

    def follow
      return false if same_user?

      return true if following?

      Follow.new(
        target:,
        follower:
      ).save
    end

    def unfollow
      return false if same_user?

      follow_record&.destroy
      true
    end

    def following? = follow_record.present?

    private

    def same_user?
      target == follower
    end

    def follow_record
      Follow.find_by(target:, follower:)
    end
  end
end
