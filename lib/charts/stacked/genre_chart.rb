module Charts
  module Stacked
    class GenreChart
      def initialize(user:, range:)
        @user = user
        @range = range
      end

      def generate
        total_issues = 0

        grouped = collection.each_with_object({}) do |issue, result|
          issue.comic.genres.each do |genre|
            result[genre.name] ||= 0
            result[genre.name] += 1
            total_issues += 1
          end
        end

        grouped.each_pair.map do |genre, issue_count|
          {
            name: genre,
            percentage: ((issue_count.to_f / total_issues) * 100).round(2),
            count: issue_count
          }
        end.sort_by { -_1[:count] }
      end

      private

      def collection = @collection ||= Issue.where(id: @user.read_issues.where(read_at: @range).select(:issue_id)).joins(comic: :genres).includes(comic: :genres)
    end
  end
end
