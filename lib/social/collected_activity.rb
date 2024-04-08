module Social
  # `record` is a CollectedIssue
  class CollectedActivity < Activity
    def content = "#{user} collected Issue ##{record.issue.issue_number} of #{record.comic} (#{record.issue.name})"

    def link = comic_issue_path(record.issue, comic_id: record.comic)

    def timestamp = record.collected_on.noon

    def image = record.issue.image
  end
end
