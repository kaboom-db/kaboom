module Charts
  class ChartCountGenerator
    attr_accessor :resource, :type

    CHART_COLOURS = [
      READ = "255, 95, 109",
      VISIT = "255, 161, 95",
      COLLECTION = "71, 188, 234",
      USER = "255, 195, 113",
      COMIC = "99, 136, 137",
      ISSUE = "157, 188, 152"
    ]

    CHART_TYPES = [
      LINE = "line",
      BAR = "bar",
      DOUGHNUT = "doughnut"
    ]

    def initialize(resource:, type:)
      @resource = resource
      @type = type
    end

    def generate
      {
        labels:,
        datasets:
      }
    end

    private

    def datasets = []

    def labels = []

    def dataset(data, colours, label)
      background_colour = colours.map do |colour|
        "rgba(#{colour}, 0.75)"
      end
      {
        type:,
        label:,
        backgroundColor: background_colour,
        borderColor: "#000",
        borderWidth: 2,
        borderRadius: 15,
        fill: true,
        tension: 0.3,
        data:
      }
    end
  end
end
