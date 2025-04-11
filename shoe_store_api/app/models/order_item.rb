class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_prices
  after_save :update_order_total
  after_destroy :update_order_total

  private

  def set_prices
    self.unit_price = product.price if unit_price.nil?
    self.total_price = quantity * unit_price if total_price.nil?
  end

  def update_order_total
    order.calculate_total_amount
    order.save
  end
end
