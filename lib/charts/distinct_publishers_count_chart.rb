module Charts
  class DistinctPublishersCountChart < ChartCountGenerator
    attr_reader :range

    def initialize(resource:, type:, range:)
      super(resource:, type:)
      @range = range
    end

    private

    def colours
      [
        "255, 191, 191",  # Red
        "255, 165, 128",  # Orange
        "255, 128, 64",   # Darker Orange
        "255, 191, 128",  # Peach
        "255, 191, 191",  # Light Red
        "255, 191, 207",  # Light Pink
        "191, 191, 255",  # Blue
        "191, 191, 255",  # Blue
        "128, 128, 255",  # Dark Blue
        "191, 191, 255",  # Blue
        "224, 224, 255",  # Light Lavender
        "191, 128, 191",  # Mauve
        "224, 128, 255",  # Lilac
        "191, 128, 191",  # Mauve
        "255, 160, 191",  # Pink
        "255, 145, 128",  # Coral
        "255, 64, 0",     # Darker Red
        "255, 128, 128",  # Light Red
        "255, 160, 255"   # Pink
      ]
    end

    def datasets
      data = grouped_issues.map { _1.read_issue_count }
      dataset = (data.any? { _1 >= 1 }) ? dataset(data, colours, "Read Issues") : nil
      [
        dataset
      ].compact
    end

    def labels
      grouped_issues.map { _1.publisher }
    end

    def grouped_issues = @grouped_issues ||= resource.read_issues.joins(issue: :comic).select("comics.publisher, COUNT(*) as read_issue_count").where(read_at: range).group("comics.publisher")
  end
end
