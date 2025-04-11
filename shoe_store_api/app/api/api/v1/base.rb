module API
  module V1
    class Base < Grape::API
      version 'v1', using: :path

      # Authentication helpers
      helpers do
        def authenticate_user!
          error!('Unauthorized. Invalid or expired token.', 401) unless current_user
        end

        def authenticate_admin!
          error!('Unauthorized. Admin access required.', 401) unless current_admin
        end

        def current_user
          return nil unless request.headers['Authorization']
          token = request.headers['Authorization'].split(' ').last
          decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!)[0]
          User.find_by(id: decoded_token['sub'])
        rescue JWT::DecodeError
          nil
        end

        def current_admin
          return nil unless request.headers['Authorization']
          token = request.headers['Authorization'].split(' ').last
          decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!)[0]
          Admin.find_by(id: decoded_token['sub'])
        rescue JWT::DecodeError
          nil
        end
      end

      # Mount API endpoints
      mount API::V1::Auth
      mount API::V1::Categories
      mount API::V1::Products
      mount API::V1::Orders
    end
  end
end
