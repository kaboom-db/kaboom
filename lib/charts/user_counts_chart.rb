module Charts
  class UserCountsChart < ChartCountGenerator
    private

    def datasets
      [
        issue_count,
        collection_count
      ]
    end

    def issue_count
      generate_count("255, 95, 109", "Read issues") do |range|
        resource.read_issues.where(read_at: range).count
      end
    end

    def collection_count
      generate_count("71, 188, 234", "Collected issues") do |range|
        resource.collected_issues.where(collected_on: range).count
      end
    end
  end
end
