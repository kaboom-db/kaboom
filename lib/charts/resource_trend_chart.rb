module Charts
  class ResourceTrendChart < FrequencyChartGenerator
    private

    def type_hash_map
      {
        FrequencyChartGenerator::DAY => VisitBucket::DAY,
        FrequencyChartGenerator::MONTH => VisitBucket::MONTH,
        FrequencyChartGenerator::YEAR => VisitBucket::YEAR
      }
    end

    def datasets
      [
        visit_count,
        read_count
      ]
    end

    def visit_count
      period = type_hash_map[range_type]
      generate_count(Constants::VISIT, "User visits") do |range|
        resource.visit_buckets.where(period:, period_start: range.first, period_end: range.last).sum(:count)
      end
    end

    def read_count
      generate_count(Constants::READ, "Read issues") do |range|
        resource.read_issues.where(read_at: range).count
      end
    end
  end
end
