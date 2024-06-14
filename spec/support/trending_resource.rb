RSpec.shared_examples "a trending resource" do |resource_type|
  it "returns the trending #{resource_type.to_s.pluralize}" do
    out_of_range = FactoryBot.create(resource_type)
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.yesterday.yesterday.beginning_of_day,
      period_end: DateTime.yesterday.yesterday.end_of_day,
      visited: out_of_range,
      count: 100
    )
    # FactoryBot.create_list(:visit, 10, visited: over_24_hours, created_at: 2.days.ago)

    trending_1 = FactoryBot.create(resource_type)
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.yesterday.beginning_of_day,
      period_end: DateTime.yesterday.end_of_day,
      visited: trending_1,
      count: 5
    )
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.current.beginning_of_day,
      period_end: DateTime.current.end_of_day,
      visited: trending_1,
      user: FactoryBot.create(:user),
      count: 2
    )
    # FactoryBot.create_list(:visit, 7, visited: trending_1)

    trending_2 = FactoryBot.create(resource_type)
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.yesterday.beginning_of_day,
      period_end: DateTime.yesterday.end_of_day,
      visited: trending_2,
      count: 6
    )
    # FactoryBot.create_list(:visit, 6, visited: trending_2)

    trending_3 = FactoryBot.create(resource_type)
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.current.beginning_of_day,
      period_end: DateTime.current.end_of_day,
      visited: trending_3,
      count: 5
    )
    # FactoryBot.create_list(:visit, 5, visited: trending_3)

    trending_4 = FactoryBot.create(resource_type)
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.yesterday.beginning_of_day,
      period_end: DateTime.yesterday.end_of_day,
      visited: trending_4,
      count: 4
    )
    # FactoryBot.create_list(:visit, 4, visited: trending_4)

    trending_5 = FactoryBot.create(resource_type)
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.current.beginning_of_day,
      period_end: DateTime.current.end_of_day,
      visited: trending_5,
      count: 3
    )
    # FactoryBot.create_list(:visit, 3, visited: trending_5)

    trending = trending_1.class.trending
    expect(trending.first).to eq trending_1
    expect(trending.second).to eq trending_2
    expect(trending.third).to eq trending_3
    expect(trending.fourth).to eq trending_4
    expect(trending.fifth).to eq trending_5
  end

  it "does not include nsfw resources" do
    comic = FactoryBot.create(:comic, nsfw: true)
    nsfw = (resource_type == :issue) ? FactoryBot.create(:issue, comic:) : comic
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.current.beginning_of_day,
      period_end: DateTime.current.end_of_day,
      visited: nsfw,
      count: 2
    )
    # FactoryBot.create_list(:visit, 2, visited: nsfw)

    trending_1 = FactoryBot.create(resource_type)
    FactoryBot.create(
      :visit_bucket,
      period: VisitBucket::DAY,
      period_start: DateTime.current.beginning_of_day,
      period_end: DateTime.current.end_of_day,
      visited: trending_1,
      count: 1
    )
    # FactoryBot.create_list(:visit, 1, visited: trending_1)

    trending = trending_1.class.trending
    expect(trending.first).to eq trending_1
    expect(trending.second).to be_nil
  end
end
