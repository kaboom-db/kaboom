# frozen_string_literal: true

class GenreChipComponent < ViewComponent::Base
  def initialize(genre:)
    @genre = genre
  end
end
