FactoryBot.define do
  factory :comic_reread do
    user
    comic
    reread_started_at { Time.current }
  end
end
