module API
  module V1
    class Auth < Grape::API
      resource :auth do
        desc 'User sign in'
        params do
          requires :email, type: String, desc: 'User email'
          requires :password, type: String, desc: 'User password'
        end
        post :sign_in do
          user = User.find_by(email: params[:email])
          if user&.valid_password?(params[:password])
            token = user.generate_jwt
            user.token = token
            UserBlueprint.render(user, view: :with_token)
          else
            error!('Invalid email or password', 401)
          end
        end

        desc 'Admin sign in'
        params do
          requires :email, type: String, desc: 'Admin email'
          requires :password, type: String, desc: 'Admin password'
        end
        post :admin_sign_in do
          admin = Admin.find_by(email: params[:email])
          if admin&.valid_password?(params[:password])
            token = admin.generate_jwt
            admin.token = token
            AdminBlueprint.render(admin, view: :with_token)
          else
            error!('Invalid email or password', 401)
          end
        end

        desc 'User sign out'
        delete :sign_out do
          authenticate_user!
          # JWT is invalidated on the client side
          { success: true }
        end

        desc 'Admin sign out'
        delete :admin_sign_out do
          authenticate_admin!
          # JWT is invalidated on the client side
          { success: true }
        end
      end
    end
  end
end
