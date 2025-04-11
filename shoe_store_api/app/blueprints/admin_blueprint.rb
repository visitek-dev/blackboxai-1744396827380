class AdminBlueprint < Blueprinter::Base
  identifier :id

  fields :email, :first_name, :last_name, :phone_number, :created_at, :updated_at

  view :normal do
    fields :email, :first_name, :last_name, :phone_number
  end

  view :with_token do
    association :token, blueprint: ->(token) { token }
  end
end
