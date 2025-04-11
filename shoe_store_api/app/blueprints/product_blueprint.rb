class ProductBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :price, :stock, :category_id, :created_at, :updated_at

  view :with_category do
    association :category, blueprint: CategoryBlueprint
  end
end
