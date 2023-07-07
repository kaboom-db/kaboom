FactoryBot.define do
  factory :user do
    email { "obi@highground.com" }
    password { "test1234" }
    username { "obi_wan" }
    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end
