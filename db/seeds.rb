require 'random_data'

User.create!(
  email: 'night1300013@gmail.com',
  password: 111111,
)

User.create!(
  email: 'night1300013@hotmail.com',
  password: 111111,
)

puts "Seed finished"
puts "#{User.count} users created"
