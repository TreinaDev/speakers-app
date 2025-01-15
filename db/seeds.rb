# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.skip_callback(:create, :before, :api_auth_user)
User.create!(first_name: 'João', last_name: 'Campus', email: 'joao@email.com', password: '123456')
User.set_callback(:create, :before, :api_auth_user)
