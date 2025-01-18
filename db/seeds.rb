Country.destroy_all
Currency.destroy_all
Rating.destroy_all
Review.destroy_all
Issue.destroy_all
Comic.destroy_all
User.destroy_all
Genre.delete_all

def create_genres
  genres = ["Crime", "Espionage", "Fantasy", "Historical", "Horror", "Comedy", "Romance", "Science Fiction", "Sport"]
  icons = ["fa-gun", "fa-user-secret", "fa-dragon", "fa-building-columns", "fa-ghost", "fa-face-laugh-squint", "fa-heart", "fa-rocket", "fa-futbol"]
  genres.zip(icons).each do |genre, icon|
    FactoryBot.create(:genre, name: genre, fa_icon: icon)
  end
end

def create_currencies
  [
    {
      symbol: "$",
      name: "US Dollar",
      symbol_native: "$",
      code: "USD",
      name_plural: "US dollars"
    },
    {
      symbol: "¥",
      name: "Japanese Yen",
      symbol_native: "￥",
      code: "JPY",
      name_plural: "Japanese yen"
    },
    {
      symbol: "£",
      name: "British Pound Sterling",
      symbol_native: "£",
      code: "GBP",
      name_plural: "British pounds sterling"
    }
  ].each do |currency|
    FactoryBot.create(:currency, **currency)
  end
end

def create_countries
  FactoryBot.create(:country, name: "United Kingdom", language_code: "en")
  FactoryBot.create(:country, name: "United States of America", language_code: "en")
  FactoryBot.create(:country, name: "Japan", language_code: "ja")
  FactoryBot.create(:country, name: "South Korea", language_code: "ko")
end

puts "\nCreating Genres"
create_genres

puts "\nCreating Currencies"
create_currencies

puts "\nCreating Countries"
create_countries

us = Country.find_by(name: "United States of America")
usd = Currency.find_by(code: "USD")
gbp = Currency.find_by(code: "GBP")

puts "\nCreating Users"
user = FactoryBot.create(:user, :confirmed, username: "comicbooklover123", email: "test@example.com", password: "123456", currency: gbp)
user2 = FactoryBot.create(:user, :confirmed, username: "comicbookhater123", email: "test2@example.com", password: "123456", currency: usd)

puts "\nImporting Comics and Issues"
# Demon Slayer
comic_0 = Comic.import(comic_vine_id: 112010)
comic_0.import_issues
FactoryBot.create(:rating, user: user, score: rand(1..10), rateable: comic_0)
FactoryBot.create(:rating, user: user2, score: rand(1..10), rateable: comic_0)
FactoryBot.create(:review, user:, title: "This is a review", content: "Review content goes here", reviewable: comic_0)
# F
comic_1 = Comic.import(comic_vine_id: 109217)
comic_1.import_issues
FactoryBot.create(:rating, user: user, score: rand(1..10), rateable: comic_1)
FactoryBot.create(:rating, user: user2, score: rand(1..10), rateable: comic_1)
# Ultimate Comics Spider-Man
comic_2 = Comic.import(comic_vine_id: 42821)
comic_2.import_issues
FactoryBot.create(:rating, user: user, score: rand(1..10), rateable: comic_2)
FactoryBot.create(:rating, user: user2, score: rand(1..10), rateable: comic_2)
# Hunger
comic_3 = Comic.import(comic_vine_id: 65628)
comic_3.import_issues
FactoryBot.create(:rating, user: user, score: rand(1..10), rateable: comic_3)
FactoryBot.create(:rating, user: user2, score: rand(1..10), rateable: comic_3)
# Hinamatsuri
comic_4 = Comic.import(comic_vine_id: 113437)
comic_4.import_issues
FactoryBot.create(:rating, user: user, score: rand(1..10), rateable: comic_4)
FactoryBot.create(:rating, user: user2, score: rand(1..10), rateable: comic_4)
# YKK
comic_5 = Comic.import(comic_vine_id: 144349)
comic_5.import_issues
FactoryBot.create(:rating, user: user, score: rand(1..10), rateable: comic_5)
FactoryBot.create(:rating, user: user2, score: rand(1..10), rateable: comic_5)

Comic.update_all(country_id: us.id)

puts "\nCreating Read Issues"
comic_0.issues.reverse_order.each_with_index do |issue, index|
  ReadIssue.create!(
    read_at: index.days.ago,
    user:,
    issue:
  )
end
ReadIssue.create!(
  read_at: Time.current,
  user:,
  issue: comic_0.issues.last
)
WishlistItem.create!(
  user:,
  wishlistable: comic_0
)
FavouriteItem.create!(
  user:,
  favouritable: comic_0
)

comic_3.issues.reverse_order.each_with_index do |issue, index|
  ReadIssue.create!(
    read_at: index.days.ago,
    user: user2,
    issue:
  )
  WishlistItem.create!(
    user:,
    wishlistable: issue
  )
end

comic_4.issues.each do |issue|
  FavouriteItem.create!(
    user:,
    favouritable: issue
  )
end
FavouriteItem.create!(
  user:,
  favouritable: comic_4
)

ReadIssue.create!(
  read_at: 2.days.ago,
  user:,
  issue: comic_5.issues.first
)

# Add random ratings to all read issues
puts "\nAdding random ratings and reviews to read issues"
reviews = [
  ["Really bad.", "This comic was really bad"],
  ["Really bad.", "This comic was really bad"],
  ["Really bad.", "This comic was really bad"],
  ["It was okay.", "This comic was okay"],
  ["It was okay.", "This comic was okay"],
  ["It was okay.", "This comic was okay"],
  ["It was okay.", "This comic was okay"],
  ["Really good..", "This comic was really good"],
  ["Really good..", "This comic was really good"],
  ["Really good..", "This comic was really good"]
]
ReadIssue.all.each do |read_issue|
  score = rand(1..10)
  # Use build and save to avoid throwing exception when the read_issue is already rated
  FactoryBot.build(:rating, user:, rateable: read_issue.issue, score:).save
  FactoryBot.build(:review, user:, reviewable: read_issue.issue, title: reviews[score - 1][0], content: reviews[score - 1][1]).save
  FactoryBot.build(:rating, user: user2, rateable: read_issue.issue, score: rand(1..10)).save
end
