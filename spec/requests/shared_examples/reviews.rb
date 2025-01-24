RSpec.shared_examples_for "a reviewable resource" do
  def perform
    get reviews_path
  end

  it "renders the header" do
    perform
    assert_select "h1", text: resource.name
  end

  it "renders a link to the resource" do
    perform
    assert_select "a[href='#{resource_path}']"
  end

  it "renders a link to the new reviews page" do
    perform
    assert_select "a[href='#{new_review_path(reviewable_type: resource.class.to_s, reviewable_id: resource.id)}']"
  end

  it "renders all the reviews" do
    review1 = FactoryBot.create(:review, reviewable: resource, title: "Review 1")
    review2 = FactoryBot.create(:review, reviewable: resource, title: "Review 2")
    perform

    assert_select "h3", text: "Review 1"
    assert_select "a[href='#{review_path(review1)}']"
    assert_select "h3", text: "Review 2"
    assert_select "a[href='#{review_path(review2)}']"
  end
end
