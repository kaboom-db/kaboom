module Charts
  class DayCountGenerator
    attr_accessor :user, :num_of_days

    def initialize(user:, num_of_days:)
      @user = user
      @num_of_days = num_of_days
    end

    def generate
      {
        labels:,
        datasets: [
          issue_count
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

    def counts
      counts = num_of_days.times.map do |i|
        day = i.days.ago
        yield day
      end
      counts.reverse
    end

    def labels
      num_of_days.times.map { _1.days.ago.strftime("%b %e") }.reverse
    end

    def dataset(data, rgb, label)
      {
        label:,
        backgroundColor: [
          "rgba(#{rgb}, 0.75)"
        ],
        borderColor: [
          "rgba(#{rgb}, 1)"
        ],
        borderRadius: 8,
        data:
      }
    end
  end
end
