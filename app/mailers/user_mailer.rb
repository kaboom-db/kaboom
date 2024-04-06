class UserMailer < ApplicationMailer
  def notify_follower(follow:)
    @user = follow.target
    @follower = follow.follower

    mail(to: @user.email, subject: "#{@follower} started following you on Kaboom!")
  end
end
