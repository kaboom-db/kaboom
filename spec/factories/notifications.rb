FactoryBot.define do
  factory :notification do
    user
    read_at { nil }
    email_sent_at { nil }
    notification_type { "created" }
    for_issue

    trait :for_issue do
      association :notifiable, factory: :issue
    end
  end
end
