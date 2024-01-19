module Charts
  class ResourceTrendChart < ChartCountGenerator
    private

    def datasets
      [
        visit_count,
        read_count
      ]
    end

    def visit_count
      generate_count("0, 64, 128", "User visits") do |range|
        resource.visits.where(created_at: range).count
      end
    end

    def read_count
      generate_count("255, 95, 109", "Read issues") do |range|
        resource.read_issues.where(read_at: range).count
      end
    end
  end
end
