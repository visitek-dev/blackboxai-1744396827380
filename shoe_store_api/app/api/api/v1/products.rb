module API
  module V1
    class Products < Grape::API
      resource :products do
        desc 'Get all products'
        params do
          optional :category_id, type: Integer, desc: 'Filter by category ID'
        end
        get do
          products = if params[:category_id]
                      Product.where(category_id: params[:category_id])
                    else
                      Product.all
                    end
          ProductBlueprint.render(products)
        end

        desc 'Get a specific product'
        params do
          requires :id, type: Integer, desc: 'Product ID'
        end
        get ':id' do
          product = Product.find(params[:id])
          ProductBlueprint.render(product)
        end

        desc 'Get a specific product with category'
        params do
          requires :id, type: Integer, desc: 'Product ID'
        end
        get ':id/with_category' do
          product = Product.find(params[:id])
          ProductBlueprint.render(product, view: :with_category)
        end

        desc 'Create a new product'
        params do
          requires :name, type: String, desc: 'Product name'
          requires :price, type: BigDecimal, desc: 'Product price'
          requires :stock, type: Integer, desc: 'Product stock'
          requires :category_id, type: Integer, desc: 'Category ID'
          optional :description, type: String, desc: 'Product description'
        end
        post do
          authenticate_admin!
          product = Product.create!(params)
          ProductBlueprint.render(product)
        end

        desc 'Update a product'
        params do
          requires :id, type: Integer, desc: 'Product ID'
          optional :name, type: String, desc: 'Product name'
          optional :price, type: BigDecimal, desc: 'Product price'
          optional :stock, type: Integer, desc: 'Product stock'
          optional :category_id, type: Integer, desc: 'Category ID'
          optional :description, type: String, desc: 'Product description'
        end
        put ':id' do
          authenticate_admin!
          product = Product.find(params[:id])
          product.update!(params.except(:id))
          ProductBlueprint.render(product)
        end

        desc 'Delete a product'
        params do
          requires :id, type: Integer, desc: 'Product ID'
        end
        delete ':id' do
          authenticate_admin!
          product = Product.find(params[:id])
          product.destroy
          { success: true }
        end
      end
    end
  end
end
