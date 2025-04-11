class OrderBlueprint < Blueprinter::Base
  identifier :id

  fields :status, :total_amount, :shipping_address, :billing_address, 
         :payment_status, :created_at, :updated_at

  association :user, blueprint: UserBlueprint, view: :normal
  association :order_items, blueprint: OrderItemBlueprint

  view :with_details do
    association :user, blueprint: UserBlueprint, view: :normal
    association :order_items, blueprint: OrderItemBlueprint, view: :with_product
  end
end
