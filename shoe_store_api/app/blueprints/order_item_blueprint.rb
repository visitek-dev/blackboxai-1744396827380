class OrderItemBlueprint < Blueprinter::Base
  identifier :id

  fields :quantity, :unit_price, :total_price, :created_at, :updated_at

  view :with_product do
    association :product, blueprint: ProductBlueprint
  end
end
