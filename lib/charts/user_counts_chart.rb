module Charts
  class UserCountsChart
    attr_accessor :user, :num_of_days, :type

    CHART_TYPES = [
      LINE = "line",
      BAR = "bar"
    ]

    def initialize(user:, num_of_days:, type:)
      @user = user
      @num_of_days = num_of_days
      @type = type
    end

    def generate
      {
        labels:,
        datasets: [
          issue_count,
          collection_count
        ]
      }
    end

    private

    def issue_count
      data = counts do |day|
        ReadIssue.where(read_at: day.beginning_of_day..day.end_of_day, user:).count
      end

      dataset(data, "255, 95, 109", "Read issues")
    end

    def collection_count
      data = counts do |day|
        CollectedIssue.where(collected_on: day, user:).count
      end

      dataset(data, "71, 188, 234", "Collected issues")
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
