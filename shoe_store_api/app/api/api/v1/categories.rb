module API
  module V1
    class Categories < Grape::API
      resource :categories do
        desc 'Get all categories'
        get do
          categories = Category.all
          CategoryBlueprint.render(categories)
        end

        desc 'Get a specific category'
        params do
          requires :id, type: Integer, desc: 'Category ID'
        end
        get ':id' do
          category = Category.find(params[:id])
          CategoryBlueprint.render(category)
        end

        desc 'Get a specific category with products'
        params do
          requires :id, type: Integer, desc: 'Category ID'
        end
        get ':id/with_products' do
          category = Category.find(params[:id])
          CategoryBlueprint.render(category, view: :with_products)
        end

        desc 'Create a new category'
        params do
          requires :name, type: String, desc: 'Category name'
          optional :description, type: String, desc: 'Category description'
        end
        post do
          authenticate_admin!
          category = Category.create!(params)
          CategoryBlueprint.render(category)
        end

        desc 'Update a category'
        params do
          requires :id, type: Integer, desc: 'Category ID'
          optional :name, type: String, desc: 'Category name'
          optional :description, type: String, desc: 'Category description'
        end
        put ':id' do
          authenticate_admin!
          category = Category.find(params[:id])
          category.update!(params.except(:id))
          CategoryBlueprint.render(category)
        end

        desc 'Delete a category'
        params do
          requires :id, type: Integer, desc: 'Category ID'
        end
        delete ':id' do
          authenticate_admin!
          category = Category.find(params[:id])
          category.destroy
          { success: true }
        end
      end
    end
  end
end
