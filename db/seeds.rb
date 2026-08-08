puts "Destroying data"

Participation.destroy_all
Operation.destroy_all
Membership.destroy_all
Group.destroy_all
User.destroy_all

puts "🌱 Seeding data..."

puts "Creating Users..."
alice = User.create!(username: "Alice", email_address: "alice@example.com", password: "password123", password_confirmation: "password123")
bob = User.create!(username: "béb", email_address: "b@b.c", password: "password123", password_confirmation: "password123")
raph = User.create!(username: "Raph", email_address: "a@b.c", password: "a", password_confirmation: "a")

puts "Creating Groups..."
ski_trip = Group.create!(
  name: "Alps Ski Trip 2024",
  description: "Tracking expenses for the winter vacation."
)
italie = Group.create!(
  name: "Italie !"
)

puts "Adding users to groups..."
Membership.create!(user: alice, group: ski_trip)
Membership.create!(user: bob, group: ski_trip)
Membership.create!(user: raph, group: ski_trip)
Membership.create!(user: raph, group: italie)

puts "Creating Operations..."

dinner_op = Operation.new(
  name: "Welcome Dinner",
  total_amount: 150.00,
  date: DateTime.now - 2.days,
  group: ski_trip,
  author: alice
)
[ alice, bob, raph ].each do |user|
  dinner_op.participations.build(user: user, amount_share: 50.00)
end
dinner_op.save!

gas_trip = Operation.new(
  name: "Gas for the drive up",
  total_amount: 60.00,
  date: DateTime.now - 3.days,
  group: ski_trip,
  author: bob
)
gas_trip.participations.build(user: bob, amount_share: 30.00)
gas_trip.participations.build(user: raph, amount_share: 30.00)
gas_trip.save!

gas_test = Operation.new(
  name: "test",
  total_amount: 60.00,
  date: DateTime.now - 1.day,
  group: ski_trip,
  author: bob
)
gas_test.participations.build(user: bob, amount_share: 30.00)
gas_test.participations.build(user: raph, amount_share: 30.00)
gas_test.save!

puts "✅ Done! Seeded #{User.count} users, #{Group.count} groups, and #{Operation.count} operations."
