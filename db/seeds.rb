5.times do
  u = User.create(
    name: Faker::Name.name,
    handle: Faker::Internet.username(specifier: 5..10)
  )
  puts "User successfully created #{u.name}:#{u.handle}"
end