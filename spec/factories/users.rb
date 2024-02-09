FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example" }
    password { "test1234" }
    sequence(:username) { |n| "user#{n}" }
    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end
