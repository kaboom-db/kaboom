class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, :confirmable

  # Validations
  validates :email, :username, presence: true
  validates_uniqueness_of :username

  def avatar
    Gravatar::Image.new(email:).get
  end
end
