# Create admin user
admin = Admin.create!(
  email: 'admin@example.com',
  password: 'password123',
  first_name: 'Admin',
  last_name: 'User',
  phone_number: '1234567890'
)

puts "Created admin user: #{admin.email}"

# Create regular user
user = User.create!(
  email: 'user@example.com',
  password: 'password123',
  first_name: 'Regular',
  last_name: 'User',
  phone_number: '0987654321'
)

puts "Created regular user: #{user.email}"

# Create shoe categories
categories = [
  { name: 'Running Shoes', description: 'High-performance shoes for runners' },
  { name: 'Casual Sneakers', description: 'Comfortable everyday wear' },
  { name: 'Formal Shoes', description: 'Elegant shoes for formal occasions' },
  { name: 'Sports Shoes', description: 'Specialized shoes for various sports' }
]

created_categories = categories.map do |category_data|
  category = Category.create!(category_data)
  puts "Created category: #{category.name}"
  category
end

# Create sample products
products = [
  {
    name: 'Speed Runner Pro',
    description: 'Professional running shoes with advanced cushioning',
    price: 129.99,
    stock: 50,
    category: created_categories[0]
  },
  {
    name: 'Urban Walker',
    description: 'Stylish and comfortable casual sneakers',
    price: 79.99,
    stock: 75,
    category: created_categories[1]
  },
  {
    name: 'Classic Oxford',
    description: 'Traditional leather formal shoes',
    price: 159.99,
    stock: 30,
    category: created_categories[2]
  },
  {
    name: 'Court Champion',
    description: 'Professional tennis shoes',
    price: 109.99,
    stock: 40,
    category: created_categories[3]
  }
]

products.each do |product_data|
  product = Product.create!(product_data)
  puts "Created product: #{product.name}"
end

# Create sample orders
orders = [
  {
    user: user,
    shipping_address: '123 Main St, City, Country',
    billing_address: '123 Main St, City, Country',
    status: 'delivered',
    payment_status: 'paid',
    order_items_attributes: [
      {
        product: Product.first,
        quantity: 2,
        unit_price: Product.first.price,
        total_price: Product.first.price * 2
      }
    ]
  },
  {
    user: user,
    shipping_address: '456 Oak St, City, Country',
    billing_address: '456 Oak St, City, Country',
    status: 'processing',
    payment_status: 'paid',
    order_items_attributes: [
      {
        product: Product.second,
        quantity: 1,
        unit_price: Product.second.price,
        total_price: Product.second.price
      },
      {
        product: Product.third,
        quantity: 3,
        unit_price: Product.third.price,
        total_price: Product.third.price * 3
      }
    ]
  }
]

orders.each do |order_data|
  order = Order.create!(
    user: order_data[:user],
    shipping_address: order_data[:shipping_address],
    billing_address: order_data[:billing_address],
    status: order_data[:status],
    payment_status: order_data[:payment_status]
  )

  order_data[:order_items_attributes].each do |item_data|
    OrderItem.create!(
      order: order,
      product: item_data[:product],
      quantity: item_data[:quantity],
      unit_price: item_data[:unit_price],
      total_price: item_data[:total_price]
    )
  end

  puts "Created order ##{order.id} for user: #{order.user.email}"
end

puts "\nSeeding completed successfully!"
