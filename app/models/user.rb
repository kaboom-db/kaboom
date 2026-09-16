class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable

  # Associations
  has_many :read_issues, dependent: :delete_all
  has_many :comics, -> { distinct }, through: :read_issues
  has_many :hidden_comics, dependent: :delete_all
  has_many :comics_hidden_from_progress, through: :hidden_comics, source: :comic
  has_many :issues_read, through: :read_issues, source: :issue
  has_many :ratings, dependent: :delete_all
  has_many :reviews, dependent: :delete_all

  has_many :wishlist_items, -> { order(position: :asc) }, dependent: :delete_all
  has_many :wishlisted_comics, through: :wishlist_items, source: :wishlistable, source_type: "Comic"
  has_many :wishlisted_issues, through: :wishlist_items, source: :wishlistable, source_type: "Issue"

  has_many :favourite_items, dependent: :delete_all
  has_many :favourited_comics, through: :favourite_items, source: :favouritable, source_type: "Comic"
  has_many :favourited_issues, through: :favourite_items, source: :favouritable, source_type: "Issue"

  has_many :collected_issues, dependent: :delete_all
  has_many :collection, through: :collected_issues, source: :issue

  has_many :visits, dependent: :delete_all
  has_many :visit_buckets, dependent: :delete_all

  has_many :follow_ers, foreign_key: :target_id, class_name: "Follow"
  has_many :followers, through: :follow_ers, source: :follower

  has_many :follow_ing, foreign_key: :follower_id, class_name: "Follow"
  has_many :following, through: :follow_ing, source: :target

  belongs_to :currency, optional: true

  # Validations
  validates :email, :username, presence: true
  validates_uniqueness_of :username

  # Scope
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def avatar
    Gravatar::Image.new(email:).get
  end

  # For duck typing
  def image = avatar

  # For duck typing
  def name = username

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
    latest_reread = comic.latest_reread_for(self)
    issues = read_issues.includes(:issue).where(issue: {comic: comic})
    if latest_reread
      issues = issues.where(read_at: latest_reread.reread_started_at..)
    end
    issues = issues.map(&:issue).uniq

    amount_read = issues.count
    ((amount_read.to_f / comic.count_of_issues) * 100).floor
  end

  def read_issues_for(comic)
    latest_reread = comic.latest_reread_for(self)

    issues = read_issues.joins(:issue).where(issue: {comic: comic}).order("issue.absolute_number DESC").order(read_at: :desc)
    if latest_reread
      issues = issues.where(read_at: latest_reread.reread_started_at..)
    end
    issues
  end

  # Returns the next issue depending on read_at or the first unread issue
  def next_up_for(comic)
    read_issues_for(comic).first&.issue&.next || comic.ordered_issues.where.not(id: issues_read_since_latest_reread(comic)).first
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
    ids = incompleted_comic_ids

    Comic
      .where(id: ids)
      .in_order_of(:id, ids)
  end

  def self.search(query:)
    words = query.downcase.split(" ")
    results = User.confirmed
    words.each { |word| results = results.where(["lower(username) LIKE ? ", "%#{word}%"]) }
    results
  end

  private

  def incompleted_comic_ids
    latest_rereads = ComicReread
      .where(user_id: id)
      .select("DISTINCT ON (comic_id) comic_id, reread_started_at")
      .order("comic_id, reread_started_at DESC")
      .index_by(&:comic_id)

    comics
      .joins(:issues)
      .where.not(id: comics_hidden_from_progress)
      .select("comics.*, MAX(read_issues.read_at) AS last_read_at")
      .group("comics.id")
      .order("last_read_at DESC")
      .filter_map do |comic|
        reread_started_at = latest_rereads[comic.id]&.reread_started_at

        read_issues_for_comic = read_issues
          .joins(:issue)
          .where(issues: {comic_id: comic.id})

        # Note: N+1 query per comic to count filtered reads
        # Each query is simple and indexed; consider denormalization if this becomes a bottleneck
        if reread_started_at
          read_issues_for_comic = read_issues_for_comic.where(
            read_issues: {read_at: reread_started_at..}
          )
        end

        comic.id if read_issues_for_comic.distinct.count(:issue_id) < comic.count_of_issues
      end
  end

  def issues_read_since_latest_reread(comic)
    latest_reread = comic.latest_reread_for(self)

    issues = read_issues
    if latest_reread
      issues = issues.where(read_at: latest_reread.reread_started_at..)
    end
    issues.pluck(:issue_id)
  end
end
