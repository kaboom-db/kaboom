module Charts
  class DistinctPublishersCountChart < ChartCountGenerator
    attr_reader :range

    def initialize(resource:, type:, range:)
      super(resource:, type:)
      @range = range
    end

    private

    def datasets
      data = collapsed_issues.second || []
      [dataset(data, ChartCountGenerator::CHART_COLOURS, "Read Issues")]
    end

    def labels
      collapsed_issues.first || []
    end

    def grouped_issues = @grouped_issues ||= resource.read_issues.joins(issue: :comic).select("comics.publisher, COUNT(*) as read_issue_count").where(read_at: range).group("comics.publisher")

    def collapsed_issues
      @collapsed_issues ||=
        begin
          i = {}
          grouped_issues.each do |issue|
            key = issue.publisher
            if issue.read_issue_count <= 5
              key = "Other"
            end
            i[key] ||= 0
            i[key] += issue.read_issue_count
          end
          i.sort_by { -_2 }.transpose
        end
    end
  end
end
