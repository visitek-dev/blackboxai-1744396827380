class RemoveProductTypeFromProducts < ActiveRecord::Migration[7.2]
  def change
    remove_column :products, :product_type, :integer
  end
end
