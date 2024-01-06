module Statistics
  class CollectedCount < BaseCount
    private

    def collection = :collected_issues

    def time_field = :collected_on
  end
end
