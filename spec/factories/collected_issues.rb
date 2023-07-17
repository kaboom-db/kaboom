FactoryBot.define do
  factory :collected_issue do
    user
    issue
    collected_on { "2023-07-17" }
  end
end
