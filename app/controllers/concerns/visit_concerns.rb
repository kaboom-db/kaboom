# frozen_string_literal: true

module VisitConcerns
  extend ActiveSupport::Concern

  def add_visit(user:, visited:)
    return if user.present? && Visit.where(user:, visited:).where("created_at >= ?", 5.minutes.ago).exists?

    Visit.create!(user:, visited:)
  end
end
