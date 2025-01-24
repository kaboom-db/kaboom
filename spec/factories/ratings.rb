FactoryBot.define do
  factory :rating do
    for_comic

    trait :for_comic do
      user
      score { 6 }
      association :rateable, factory: :comic
    end

    trait :for_issue do
      user
      score { 6 }
      association :rateable, factory: :issue
    end
  end
end
