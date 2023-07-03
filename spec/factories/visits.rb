FactoryBot.define do
  factory :visit do
    for_comic

    trait :for_comic do
      user { nil }
      association :visited, factory: :comic
    end

    trait :for_issue do
      user { nil }
      association :visited, factory: :issue
    end
  end
end
