class DevisePreview < ActionMailer::Preview
  def confirmation_instructions
    record = User.new(username: "BobMarley")
    token = "fake_token"
    Devise::Mailer.confirmation_instructions(record, token)
  end

  def email_changed
    record = User.new(username: "BobMarley", unconfirmed_email: "test@example.com")
    Devise::Mailer.email_changed(record)
  end

  def password_change
    record = User.new(username: "BobMarley")
    Devise::Mailer.password_change(record)
  end

  def reset_password_instructions
    record = User.new(username: "BobMarley")
    token = "fake_token"
    Devise::Mailer.reset_password_instructions(record, token)
  end
end
