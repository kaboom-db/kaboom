module Charts
  class ResourceTrendChart < FrequencyChartGenerator
    private

    def datasets
      [
        visit_count,
        read_count
      ]
    end

    def visit_count
      generate_count(Constants::VISIT, "User visits") do |range|
        resource.visits.where(created_at: range).count
      end
    end

    def read_count
      generate_count(Constants::READ, "Read issues") do |range|
        resource.read_issues.where(read_at: range).count
      end
    end
  end
end
