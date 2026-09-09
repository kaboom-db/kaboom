json.array! @incompleted_comics do |comic|
  json.id comic.id
  json.name comic.name
  json.image comic.image
  json.count_of_issues comic.count_of_issues
  json.deck comic.deck
  json.description comic.description
  next_issue = @user.next_up_for(comic)
  if next_issue
    json.next_issue do
      json.id next_issue.id
      json.name next_issue.name
      json.image next_issue.image
      json.cover_date next_issue.cover_date
      json.store_date next_issue.store_date
      json.deck next_issue.deck
      json.description next_issue.description
      json.issue_number next_issue.issue_number
      json.absolute_number next_issue.absolute_number
    end
  end
end
