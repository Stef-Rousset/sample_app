# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


puts "create a main user"

User.create!(name: "Example user", email: "example@railstutorial.org",
            password: "foobar", password_confirmation: "foobar",
            admin: true, activated: true, activated_at: Time.zone.now)

puts "main user done"

puts "create 90 additionals users"
90.times do |number|
  name = Faker::Name.name
  email = "example-#{number+1}@railstutorial.org"
  password = 'password'
  User.create!(name: name, email: email, password: password,
               password_confirmation: password, activated: true,
               activated_at: Time.zone.now)
end
puts "additionals users done"
