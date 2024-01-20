module Charts
  class ChartCountGenerator
    attr_accessor :resource, :num_of_elms, :type, :range_type, :start_time

    CHART_COLOURS = [
      READ = "255, 95, 109",
      VISIT = "0, 64, 128",
      COLLECTION = "71, 188, 234",
      USER = "255, 195, 113",
      COMIC = "99, 136, 137",
      ISSUE = "157, 188, 152"
    ]

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
      MONTH => "%b %Y",
      YEAR => "%Y"
    }

    def initialize(resource:, num_of_elms:, type:, range_type:, start_time: Time.current)
      @resource = resource
      @num_of_elms = num_of_elms
      @type = type
      @range_type = range_type
      @start_time = start_time

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
        days = i.send(range_type)
        day = start_time - days
        beginning_of_range = day.send(range_start)
        end_of_range = day.send(range_end)
        range = (beginning_of_range..end_of_range)
        yield range
      end.reverse

      dataset(data, rgb, label)
    end

    def labels
      num_of_elms.times.map do |elm|
        days = elm.send(range_type)
        (start_time - days).strftime(RANGE_FORMATS[range_type])
      end.reverse
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
        borderWidth: 2,
        borderRadius: 5,
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
