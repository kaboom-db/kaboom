FactoryBot.define do
  factory :issue do
    aliases { "MyText" }
    api_detail_url { "MyString" }
    cover_date { "2023-06-25" }
    date_last_updated { "2023-06-25 11:38:57" }
    deck { "MyText" }
    description { "MyText" }
    cv_id { 1 }
    image { "MyString" }
    issue_number { 1.5 }
    name { "MyString" }
    site_detail_url { "MyString" }
    store_date { "2023-06-25" }
    comic
  end
end
