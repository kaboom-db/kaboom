# frozen_string_literal: true

module VisitConcerns
  extend ActiveSupport::Concern

  def add_visit(user:, visited:)
    Visit.create!(user:, visited:)
  end
end
