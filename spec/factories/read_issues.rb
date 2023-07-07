FactoryBot.define do
  factory :read_issue do
    read_at { "2023-07-07 18:47:56" }
    user
    issue
  end
end
