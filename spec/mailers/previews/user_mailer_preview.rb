# Preview all emails at http://localhost:3000/rails/mailers/user
class UserMailerPreview < ActionMailer::Preview
  def notify_follower
    follow = Follow.new(target: User.first, follower: User.second)
    UserMailer.notify_follower(follow:)
  end
end
