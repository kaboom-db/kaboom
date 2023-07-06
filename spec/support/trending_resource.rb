RSpec.shared_examples "a trending resource" do |resource_type|
  it "returns the top 5 trending #{resource_type.to_s.pluralize}" do
    over_24_hours = FactoryBot.create(resource_type)
    FactoryBot.create_list(:visit, 10, visited: over_24_hours, created_at: 2.days.ago)

    trending_1 = FactoryBot.create(resource_type)
    FactoryBot.create_list(:visit, 7, visited: trending_1)

    trending_2 = FactoryBot.create(resource_type)
    FactoryBot.create_list(:visit, 6, visited: trending_2)

    trending_3 = FactoryBot.create(resource_type)
    FactoryBot.create_list(:visit, 5, visited: trending_3)

    trending_4 = FactoryBot.create(resource_type)
    FactoryBot.create_list(:visit, 4, visited: trending_4)

    trending_5 = FactoryBot.create(resource_type)
    FactoryBot.create_list(:visit, 3, visited: trending_5)

    trending = trending_1.class.trending
    expect(trending.first).to eq trending_1
    expect(trending.second).to eq trending_2
    expect(trending.third).to eq trending_3
    expect(trending.fourth).to eq trending_4
    expect(trending.fifth).to eq trending_5
  end
end
