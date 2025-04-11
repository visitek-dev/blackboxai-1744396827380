# Shoe Store API

A Rails 7.2.0 API for managing a shoe store, built with Grape API, Blueprinter, and JWT authentication.

## Features

- User and Admin authentication using Devise with JWT
- RESTful API endpoints for managing products and categories
- Role-based access control
- JSON serialization using Blueprinter
- Docker support for easy deployment

## API Endpoints

### Authentication

- `POST /api/v1/auth/sign_in` - User sign in
- `POST /api/v1/auth/admin_sign_in` - Admin sign in
- `DELETE /api/v1/auth/sign_out` - User sign out
- `DELETE /api/v1/auth/admin_sign_out` - Admin sign out

### Categories

- `GET /api/v1/categories` - List all categories
- `GET /api/v1/categories/:id` - Get a specific category
- `GET /api/v1/categories/:id/with_products` - Get a category with its products
- `POST /api/v1/categories` - Create a new category (Admin only)
- `PUT /api/v1/categories/:id` - Update a category (Admin only)
- `DELETE /api/v1/categories/:id` - Delete a category (Admin only)

### Products

- `GET /api/v1/products` - List all products
- `GET /api/v1/products?category_id=1` - List products by category
- `GET /api/v1/products/:id` - Get a specific product
- `GET /api/v1/products/:id/with_category` - Get a product with its category
- `POST /api/v1/products` - Create a new product (Admin only)
- `PUT /api/v1/products/:id` - Update a product (Admin only)
- `DELETE /api/v1/products/:id` - Delete a product (Admin only)

### Orders

- `GET /api/v1/orders` - List all orders (Admin) or user's orders (User)
- `GET /api/v1/orders/:id` - Get a specific order with details
- `POST /api/v1/orders` - Create a new order (User)
  ```json
  {
    "shipping_address": "123 Main St",
    "billing_address": "123 Main St",
    "order_items": [
      {
        "product_id": 1,
        "quantity": 2
      }
    ]
  }
  ```
- `PUT /api/v1/orders/:id/status` - Update order status (Admin only)
  ```json
  {
    "status": "processing",
    "payment_status": "paid"
  }
  ```
- `DELETE /api/v1/orders/:id` - Cancel an order (User can cancel their own orders, Admin can cancel any order)

## Setup

1. Clone the repository
2. Copy `.env.sample` to `.env` and update the values
3. Build the Docker image:
   ```bash
   docker build -t shoe-store-api .
   ```
4. Run the container:
   ```bash
   docker run -d -p 3000:3000 \
     --env-file .env \
     --name shoe-store-api \
     shoe-store-api
   ```

## Development

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Setup the database:
   ```bash
   rails db:create db:migrate db:seed
   ```

3. Start the server:
   ```bash
   rails server
   ```

## Authentication

The API uses JWT tokens for authentication. Include the token in the Authorization header:

```
Authorization: Bearer your-token-here
```

## Models

### User
- email
- password
- first_name
- last_name
- phone_number

### Admin
- email
- password
- first_name
- last_name
- phone_number

### Category
- name
- description
- has_many :products

### Product
- name
- description
- price
- stock
- belongs_to :category

## Testing

Run the test suite:

```bash
rails test
```

## Docker

The application includes a production-ready Dockerfile. Build and run using:

```bash
# Build the image
docker build -t shoe-store-api .

# Run the container
docker run -d -p 3000:3000 \
  --env-file .env \
  --name shoe-store-api \
  shoe-store-api
```

## Environment Variables

See `.env.sample` for all required environment variables.
