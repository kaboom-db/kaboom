module Statistics
  class UserMostActivityCount
    attr_reader :year, :user

    def initialize(year:, user:)
      @year = year
      @user = user
    end

    def read
      query("read_issues", "read_at")
    end

    def collected
      query("collected_issues", "collected_on")
    end

    private

    def query(relation, time_field)
      filters = {relation => {"user" => user, time_field => beginning_of_year..end_of_year}}.deep_symbolize_keys
      Comic.select("comics.*, COUNT(#{relation}.id) AS activity_count")
        .joins(issues: relation.to_sym)
        .where(filters)
        .group("comics.id")
        .order("activity_count DESC")
        .limit(5)
    end

    def beginning_of_year
      return Time.zone.at(0) if year == BaseCount::ALLTIME

      Time.new(year.to_i)
    end

    def end_of_year
      return Time.current if year == BaseCount::ALLTIME

      beginning_of_year.end_of_year
    end
  end
end
