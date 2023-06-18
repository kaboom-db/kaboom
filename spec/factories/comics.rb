FactoryBot.define do
  factory :comic do
    aliases { "MyText" }
    api_detail_url { "MyString" }
    count_of_issues { 1 }
    date_last_updated { "2023-06-18 15:15:49" }
    deck { "MyText" }
    description { "MyText" }
    cv_id { 1 }
    image { "MyString" }
    name { "MyString" }
    publisher { "MyString" }
    site_detail_url { "MyString" }
    start_year { 1 }
  end
end
