FactoryBot.define do
  factory :review do
    for_comic

    trait :for_comic do
      title { "MyString" }
      content { "MyText" }
      user
      association :reviewable, factory: :comic
    end

    trait :for_issue do
      title { "MyString" }
      content { "MyText" }
      user
      association :reviewable, factory: :issue
    end
  end
end
