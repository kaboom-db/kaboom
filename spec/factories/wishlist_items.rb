FactoryBot.define do
  factory :wishlist_item do
    for_comic

    trait :for_comic do
      user
      association :wishlistable, factory: :comic
    end

    trait :for_issue do
      user
      association :wishlistable, factory: :issue
    end
  end
end
