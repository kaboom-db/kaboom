def collect
  comic = Comic.find(5) # Find the comic
  user = User.find_by!(username: "crxssed") # Find yourself
  prices = [
    # Enter your individual volume prices here
  ]
  issues = comic.ordered_issues
  prices.each_with_index do |price, index|
    issue = issues[index]
    ci = CollectedIssue.where(user:, issue:)
    ci.update(price_paid: price)
  end
end
