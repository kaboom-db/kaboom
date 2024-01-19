module Charts
  class ResourceTrendChart
    attr_accessor :resource, :num_of_days, :type

    CHART_TYPES = [
      LINE = "line",
      BAR = "bar"
    ]

    def initialize(resource:, num_of_days:, type:)
      @resource = resource
      @num_of_days = num_of_days
      @type = type
    end

    def generate
      {
        labels:,
        datasets: [
          visit_count,
          read_count
        ]
      }
    end

    private

    def visit_count
      data = counts do |day|
        resource.visits.where(created_at: day.beginning_of_day..day.end_of_day).count
      end

      dataset(data, "0, 64, 128", "User visits")
    end

    def read_count
      data = counts do |day|
        resource.read_issues.where(read_at: day.beginning_of_day..day.end_of_day).count
      end

      dataset(data, "255, 95, 109", "Read issues")
    end

    def counts
      num_of_days.times.map do |i|
        day = i.days.ago
        yield day
      end.reverse
    end

    def labels
      num_of_days.times.map { _1.days.ago.strftime("%b %-d") }.reverse
    end

    def dataset(data, rgb, label)
      {
        type:,
        label:,
        backgroundColor: [
          "rgba(#{rgb}, 0.10)"
        ],
        borderColor: [
          "rgba(#{rgb}, 1)"
        ],
        borderRadius: 2,
        fill: true,
        tension: 0.3,
        data:
      }
    end
  end
end
