module Charts
  class ChartCountGenerator
    attr_accessor :resource, :num_of_elms, :type, :range_type

    CHART_TYPES = [
      LINE = "line",
      BAR = "bar"
    ]

    RANGE_TYPES = [
      DAY = :days,
      MONTH = :months,
      YEAR = :years
    ]

    START_RANGES = {
      DAY => :beginning_of_day,
      MONTH => :beginning_of_month,
      YEAR => :beginning_of_year
    }

    END_RANGES = {
      DAY => :end_of_day,
      MONTH => :end_of_month,
      YEAR => :end_of_year
    }

    RANGE_FORMATS = {
      DAY => "%b %-d",
      MONTH => "%b",
      YEAR => "%Y"
    }

    def initialize(resource:, num_of_elms:, type:, range_type:)
      @resource = resource
      @num_of_elms = num_of_elms
      @type = type
      @range_type = range_type

      raise "Invalid range type" unless RANGE_TYPES.include?(range_type)
    end

    def generate
      {
        labels:,
        datasets:
      }
    end

    private

    def datasets = []

    def generate_count(rgb, label)
      data = num_of_elms.times.map do |i|
        day = i.send(range_type).ago
        beginning_of_range = day.send(range_start)
        end_of_range = day.send(range_end)
        range = (beginning_of_range..end_of_range)
        yield range
      end.reverse

      dataset(data, rgb, label)
    end

    def labels
      num_of_elms.times.map { _1.send(range_type).ago.strftime(RANGE_FORMATS[range_type]) }.reverse
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

    def range_start
      START_RANGES[range_type]
    end

    def range_end
      END_RANGES[range_type]
    end
  end
end
