FactoryBot.define do
  factory :visit_bucket do
    period { "DAY" }
    period_start { "2024-06-14 17:53:34" }
    period_end { "2024-06-14 17:53:34" }
    user
    for_comic

    trait :for_comic do
      association :visited, factory: :comic
    end

    trait :for_issue do
      association :visited, factory: :issue
    end
  end
end
