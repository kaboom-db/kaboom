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
