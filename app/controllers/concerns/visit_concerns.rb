# frozen_string_literal: true

module VisitConcerns
  extend ActiveSupport::Concern

  def add_visit(user:, visited:)
    return if request.is_crawler?
    return if user.present? && VisitBucket.where(user:, visited:, period: VisitBucket::DAY).where("updated_at >= ?", 5.minutes.ago).exists?

    add_visit_to_bucket(period: VisitBucket::DAY, user:, visited:)
    # TODO: Re-enable this when needed.
    # add_visit_to_bucket(period: VisitBucket::MONTH, user:, visited:)
    # add_visit_to_bucket(period: VisitBucket::YEAR, user:, visited:)
  end

  def add_visit_to_bucket(period:, user:, visited:)
    period_start, period_end = {
      VisitBucket::DAY => [DateTime.current.beginning_of_day.to_i, DateTime.current.end_of_day.to_i],
      VisitBucket::MONTH => [DateTime.current.beginning_of_month.to_i, DateTime.current.end_of_month.to_i],
      VisitBucket::YEAR => [DateTime.current.beginning_of_year.to_i, DateTime.current.end_of_year.to_i]
    }[period]

    bucket = VisitBucket.find_or_initialize_by(user:, visited:, period:, period_start:, period_end:)
    existing_count = bucket&.count || 0
    bucket.update(count: existing_count + 1)
  end
end
