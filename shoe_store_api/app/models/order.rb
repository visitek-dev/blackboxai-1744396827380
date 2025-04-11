class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :shipping_address, :billing_address, presence: true
  validates :status, inclusion: { in: %w[pending processing shipped delivered cancelled] }
  validates :payment_status, inclusion: { in: %w[pending paid refunded failed] }

  before_save :calculate_total_amount

  def calculate_total_amount
    self.total_amount = order_items.sum(&:total_price)
  end

  def add_product(product, quantity)
    current_item = order_items.find_by(product: product)

    if current_item
      current_item.quantity += quantity
      current_item.save
    else
      order_items.create(
        product: product,
        quantity: quantity,
        unit_price: product.price,
        total_price: product.price * quantity
      )
    end

    calculate_total_amount
    save
  end
end
