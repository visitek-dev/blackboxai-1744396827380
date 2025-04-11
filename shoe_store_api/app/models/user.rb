class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  # Relationships
  has_many :orders, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
end
