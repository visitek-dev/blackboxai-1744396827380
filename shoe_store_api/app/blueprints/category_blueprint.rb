class CategoryBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :created_at, :updated_at

  view :with_products do
    association :products, blueprint: ProductBlueprint
  end
end
