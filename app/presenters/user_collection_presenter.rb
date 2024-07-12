class UserCollectionPresenter
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def total_price_paid = collected_issues.sum(&:price_paid)

  def overall_collection_progress = "#{total_number_of_issues} / #{total_to_collect}"

  def grouped_collection = collected_issues.sort_by { _1.issue.absolute_number }.group_by { _1.comic }

  private

  def total_number_of_issues = collected_issues.load.size

  def total_to_collect = collected_issues.map { _1.comic }.uniq.sum { _1.count_of_issues }

  def collected_issues = @collected_issues ||= user.collected_issues.includes(:comic)
end
