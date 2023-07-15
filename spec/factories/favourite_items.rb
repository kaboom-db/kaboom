FactoryBot.define do
  factory :favourite_item do
    for_comic

    trait :for_comic do
      user
      association :favouritable, factory: :comic
    end

    trait :for_issue do
      user
      association :favouritable, factory: :issue
    end
  end
end
