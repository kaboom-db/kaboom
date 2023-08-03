# frozen_string_literal: true

require "rails_helper"

RSpec.describe HistoryItemComponent, type: :component do
  before do
    @time = Time.current
    comic = FactoryBot.create(:comic, name: "Venom")
    issue = FactoryBot.create(:issue, comic:, name: "Issue 1", image: "/path/to/image.jpg")
    read_issue = FactoryBot.create(:read_issue, issue:, user: FactoryBot.create(:user), read_at: @time)
    render_inline(described_class.new(read_issue:))
  end

  it "renders the issue poster" do
    expect(page).to have_css "img[src='/path/to/image.jpg']"
  end

  it "renders the comic name" do
    expect(page).to have_css "small", text: "Venom"
  end

  it "renders the issue name" do
    expect(page).to have_css "p.font-bold", text: "Issue 1"
  end

  it "renders the read at time" do
    expect(page).to have_css "span.font-bold", text: @time.strftime("%-d %b %H:%M")
  end
end
