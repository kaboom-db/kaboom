module Charts
  class ChartCountGenerator
    attr_accessor :resource, :type

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
