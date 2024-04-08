class Follow < ApplicationRecord
  # associations
  belongs_to :target, class_name: "User"
  belongs_to :follower, class_name: "User"

  # callbacks
  after_create :notify_target!

  def social_class = Social::FollowedActivity

  private

  def notify_target!
    UserMailer.notify_follower(follow: self).deliver_later if target.allow_email_notifications?
  end
end
