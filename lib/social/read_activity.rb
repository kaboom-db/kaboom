module Social
  # `record` is a ReadIssue
  class ReadActivity < Activity
    def content = "#{user} read Issue ##{record.issue.issue_number} of #{record.comic} (#{record.issue.name})"

    def link = comic_issue_path(record.issue, comic_id: record.comic)

    def timestamp = record.read_at

    def image = record.issue.image
  end
end
