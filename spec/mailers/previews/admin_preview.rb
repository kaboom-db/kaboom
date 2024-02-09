# Preview all emails at http://localhost:3000/rails/mailers/admin
class AdminPreview < ActionMailer::Preview
  def notify_missing_issues
    comic = Comic.first
    AdminMailer.notify_missing_issues(comic:, failed: ["1, 2, 3, 4"])
  end
end
