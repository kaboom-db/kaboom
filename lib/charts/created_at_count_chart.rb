module Charts
  class CreatedAtCountChart < FrequencyChartGenerator
    def initialize(resource:, num_of_elms:, type:, range_type:, rgb:, label:, start_time: Time.current)
      super(resource:, num_of_elms:, type:, range_type:, start_time:)
      @rgb = rgb
      @label = label
    end

    private

    def datasets = [count]

    def count
      generate_count(@rgb, @label) do |range|
        resource.where(created_at: range).count
      end
    end
  end
end
