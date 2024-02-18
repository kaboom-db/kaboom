module Charts
  class UserCountsChart < FrequencyChartGenerator
    private

    def datasets
      [
        issue_count,
        collection_count
      ]
    end

    def issue_count
      generate_count(ChartCountGenerator::READ, "Read issues") do |range|
        resource.read_issues.where(read_at: range).count
      end
    end

    def collection_count
      generate_count(ChartCountGenerator::COLLECTION, "Collected issues") do |range|
        resource.collected_issues.where(collected_on: range).count
      end
    end
  end
end
