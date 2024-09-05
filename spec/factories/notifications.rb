FactoryBot.define do
  factory :notification do
    user
    read_at { nil }
    email_sent_at { nil }
    notification_type { "new_issue" }
    for_issue

    trait :for_issue do
      association :notifiable, factory: :issue
    end
  end
end
