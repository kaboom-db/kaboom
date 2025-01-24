# frozen_string_literal: true

require "rails_helper"

RSpec.describe Svg::RatingCircleComponent, type: :component do
  it "renders a rating circle with values" do
    render_inline(described_class.new(rating: 9))
    expect(page).to have_css "svg[width='215']"
    expect(page).to have_css "svg[height='215']"
    expect(page).to have_css "svg[viewbox='0 0 430 430']"
    expect(page).to have_css "circle[r='200']", count: 2
    expect(page).to have_css "circle[cx='215']", count: 2
    expect(page).to have_css "circle[cy='215']", count: 2
    expect(page).to have_css "circle[stroke-dasharray='1256.6370614359173']"
    expect(page).to have_css "circle[stroke-dashoffset='125.66370614359174']"
    expect(page).to have_css "circle[transform='rotate(-90 215 215)']"
    expect(page).to have_css "animate[values='1256.6370614359173;125.66370614359174']"
    expect(page).to have_css "text", text: "90"
  end

  context "when rating is greater than 100" do
    it "clamps to 100" do
      render_inline(described_class.new(rating: 11))
      expect(page).to have_css "text", text: "100"
    end
  end

  context "when a multiplier is present" do
    it "increases the radius" do
      render_inline(described_class.new(rating: 9, multiplier: 2))
      expect(page).to have_css "svg[width='415']"
      expect(page).to have_css "svg[height='415']"
      expect(page).to have_css "svg[viewbox='0 0 830 830']"
      expect(page).to have_css "circle[r='400']", count: 2
      expect(page).to have_css "circle[cx='415']", count: 2
      expect(page).to have_css "circle[cy='415']", count: 2
      expect(page).to have_css "circle[transform='rotate(-90 415 415)']"
    end
  end

  context "when custom classes are present" do
    it "renders the classes" do
      render_inline(described_class.new(rating: 9, multiplier: 1, classes: "hello"))
      expect(page).to have_css "svg.hello"
    end
  end

  context "when the rating is within one third" do
    it "renders the colour" do
      render_inline(described_class.new(rating: 1))
      expect(page).to have_css "circle[stroke='#f6504b']"
    end
  end

  context "when the rating is within two thirds" do
    it "renders the colour" do
      render_inline(described_class.new(rating: 4))
      expect(page).to have_css "circle[stroke='#e0ca3c']"
    end
  end

  context "when the rating is within three thirds" do
    it "renders the colour" do
      render_inline(described_class.new(rating: 7))
      expect(page).to have_css "circle[stroke='#00df77']"
    end
  end
end
