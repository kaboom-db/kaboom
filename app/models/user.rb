class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable

  # Associations
  has_many :read_issues, dependent: :delete_all
  has_many :comics, -> { distinct }, through: :read_issues
  has_many :issues_read, through: :read_issues, source: :issue
  has_many :wishlist_items, dependent: :delete_all
  has_many :wishlisted_comics, through: :wishlist_items, source: :wishlistable, source_type: "Comic"
  has_many :wishlisted_issues, through: :wishlist_items, source: :wishlistable, source_type: "Issue"
  has_many :favourite_items, dependent: :delete_all
  has_many :favourited_comics, through: :favourite_items, source: :favouritable, source_type: "Comic"
  has_many :favourited_issues, through: :favourite_items, source: :favouritable, source_type: "Issue"
  has_many :collected_issues, dependent: :delete_all
  has_many :collection, through: :collected_issues, source: :issue
  has_many :visits, dependent: :delete_all

  # Validations
  validates :email, :username, presence: true
  validates_uniqueness_of :username

  def avatar
    Gravatar::Image.new(email:).get
  end

  def to_param
    username
  end

  def to_s
    username
  end

  def last_read_issue = read_issues.order(read_at: :desc).first

  def first_read_issue(year:)
    return unless year == Statistics::BaseCount::ALLTIME || Date.new(year.to_i).gregorian?

    if year == Statistics::BaseCount::ALLTIME
      read_issues.order(read_at: :asc).first
    else
      date = Time.new(year.to_i)
      read_issues.where(read_at: date.beginning_of_year..date.end_of_year).order(read_at: :asc).first
    end
  end

  def first_collected_issue(year:)
    return unless year == Statistics::BaseCount::ALLTIME || Date.new(year.to_i).gregorian?

    if year == Statistics::BaseCount::ALLTIME
      collected_issues.order(collected_on: :asc).first
    else
      date = Time.new(year.to_i)
      collected_issues.where(collected_on: date.beginning_of_year..date.end_of_year).order(collected_on: :asc).first
    end
  end

  def progress_for(comic)
    amount_read = issues_read.where(comic:).distinct.count
    ((amount_read.to_f / comic.count_of_issues) * 100).floor
  end

  def read_issues_for(comic)
    read_issues.joins(:issue).where(issue: {comic:}).order("issue.absolute_number DESC").order(read_at: :desc)
  end

  # Returns the next issue depending on read_at or the first unread issue
  def next_up_for(comic)
    read_issues_for(comic).first&.issue&.next || comic.ordered_issues.where.not(id: issues_read).first
  end

  # TODO: Possibly make this more efficient with indexes?
  def completed_comics
    comics
      .joins(:issues)
      .select("comics.*, MAX(read_issues.read_at) AS last_read_at")
      .group("comics.id")
      .having("COUNT(DISTINCT issues.id) = comics.count_of_issues")
      .order("last_read_at DESC")
  end

  def incompleted_comics
    comics
      .joins(:issues)
      .select("comics.*, MAX(read_issues.read_at) AS last_read_at")
      .group("comics.id")
      .having("COUNT(DISTINCT issues.id) < comics.count_of_issues")
      .order("last_read_at DESC")
  end
end
