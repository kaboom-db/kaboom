# frozen_string_literal: true

class TopReviewComponent < ViewComponent::Base
  CLASSES = [
    "from-[#f6504b] hover:bg-[#f6504b] md:ml-16",
    "from-[#e0ca3c] hover:bg-[#e0ca3c] md:ml-8",
    "from-[#00df77] hover:bg-[#00df77]"
  ]

  def initialize(review:)
    @review = review
    @classes = review ? CLASSES[review.tier] : nil
  end
end
