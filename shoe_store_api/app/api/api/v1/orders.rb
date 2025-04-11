module API
  module V1
    class Orders < Grape::API
      resource :orders do
        desc 'Get all orders'
        get do
          authenticate_user!
          orders = if current_admin
                    Order.all
                  else
                    current_user.orders
                  end
          OrderBlueprint.render(orders)
        end

        desc 'Get a specific order'
        params do
          requires :id, type: Integer, desc: 'Order ID'
        end
        get ':id' do
          authenticate_user!
          order = Order.find(params[:id])
          
          # Ensure users can only access their own orders
          unless current_admin || order.user_id == current_user.id
            error!('Unauthorized', 401)
          end
          
          OrderBlueprint.render(order, view: :with_details)
        end

        desc 'Create a new order'
        params do
          requires :shipping_address, type: String, desc: 'Shipping address'
          requires :billing_address, type: String, desc: 'Billing address'
          requires :order_items, type: Array do
            requires :product_id, type: Integer, desc: 'Product ID'
            requires :quantity, type: Integer, desc: 'Quantity'
          end
        end
        post do
          authenticate_user!
          
          ActiveRecord::Base.transaction do
            order = current_user.orders.create!(
              shipping_address: params[:shipping_address],
              billing_address: params[:billing_address],
              status: 'pending',
              payment_status: 'pending'
            )

            params[:order_items].each do |item|
              product = Product.find(item[:product_id])
              
              # Check stock availability
              if product.stock < item[:quantity]
                error!("Insufficient stock for product: #{product.name}", 422)
              end
              
              # Decrease product stock
              product.update!(stock: product.stock - item[:quantity])
              
              # Add product to order
              order.add_product(product, item[:quantity])
            end

            OrderBlueprint.render(order, view: :with_details)
          end
        end

        desc 'Update order status'
        params do
          requires :id, type: Integer, desc: 'Order ID'
          requires :status, type: String, values: %w[pending processing shipped delivered cancelled], desc: 'Order status'
          optional :payment_status, type: String, values: %w[pending paid refunded failed], desc: 'Payment status'
        end
        put ':id/status' do
          authenticate_admin!
          order = Order.find(params[:id])
          
          # If order is being cancelled, restore product stock
          if params[:status] == 'cancelled' && order.status != 'cancelled'
            order.order_items.each do |item|
              item.product.update!(stock: item.product.stock + item.quantity)
            end
          end
          
          order.update!(
            status: params[:status],
            payment_status: params[:payment_status] || order.payment_status
          )
          
          OrderBlueprint.render(order, view: :with_details)
        end

        desc 'Cancel an order'
        params do
          requires :id, type: Integer, desc: 'Order ID'
        end
        delete ':id' do
          authenticate_user!
          order = Order.find(params[:id])
          
          # Ensure users can only cancel their own orders
          unless current_admin || order.user_id == current_user.id
            error!('Unauthorized', 401)
          end
          
          # Only allow cancellation of pending or processing orders
          unless %w[pending processing].include?(order.status)
            error!('Cannot cancel order in current status', 422)
          end
          
          ActiveRecord::Base.transaction do
            # Restore product stock
            order.order_items.each do |item|
              item.product.update!(stock: item.product.stock + item.quantity)
            end
            
            order.update!(status: 'cancelled')
          end
          
          OrderBlueprint.render(order, view: :with_details)
        end
      end
    end
  end
end
