class Category < ApplicationRecord
  # Relationships
  has_many :products, dependent: :destroy

  # Validations
  validates :name, presence: true, uniqueness: true
end
