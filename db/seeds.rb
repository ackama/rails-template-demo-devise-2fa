# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

10.times do |n|
  User.find_or_create_by!(email: "foo-#{n}@example.com") do |user|
    Rails.logger.debug { "Creating User: #{user.email}" }
    user.password = "verylongpassword"
    user.otp_secret = User.generate_otp_secret
    user.otp_required_for_login = true
  end
end
