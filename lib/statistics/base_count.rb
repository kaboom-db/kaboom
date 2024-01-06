module Statistics
  class BaseCount
    attr_reader :year, :user

    ALLTIME = "alltime"

    def initialize(year:, user:)
      @year = year
      @user = user
    end

    def self.all_counts_for(year:, user:)
      [
        Statistics::ReadCount.new(year:, user:),
        Statistics::CollectedCount.new(year:, user:)
      ]
    end

    def records
      @records ||= user.send(collection).where(build_filters)
    end

    def count
      records.size
    end

    private

    def collection = raise "Implement in subclass"

    def time_field = raise "Implement in subclass"

    def build_filters
      filters = {}
      filters[time_field] = beginning_of_year..end_of_year
      filters
    end

    def beginning_of_year
      return Time.zone.at(0) if year == ALLTIME

      Time.new(year.to_i)
    end

    def end_of_year
      return Time.current if year == ALLTIME

      beginning_of_year.end_of_year
    end
  end
end
