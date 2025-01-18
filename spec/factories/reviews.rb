FactoryBot.define do
  factory :review do
    title { "MyString" }
    content { "MyText" }
    user { nil }
    reviewable_type { "MyString" }
    reviewable_id { "" }
  end
end
