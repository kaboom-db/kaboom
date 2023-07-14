class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable

  # Associations
  has_many :read_issues, dependent: :delete_all
  has_many :issues_read, through: :read_issues, source: :issue
  has_many :wishlist_items, dependent: :delete_all
  has_many :wishlisted_comics, through: :wishlist_items, source: :wishlistable, source_type: "Comic"
  has_many :wishlisted_issues, through: :wishlist_items, source: :wishlistable, source_type: "Issue"
  has_many :visits, dependent: :delete_all

  # Validations
  validates :email, :username, presence: true
  validates_uniqueness_of :username

  def avatar
    Gravatar::Image.new(email:).get
  end
end
