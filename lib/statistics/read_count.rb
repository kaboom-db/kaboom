module Statistics
  class ReadCount < BaseCount
    private

    def collection = :read_issues

    def time_field = :read_at
  end
end
