puts "🌱 Seeding data..."

# 1. Clean the slate (Order matters due to foreign keys!)
Participation.destroy_all
Operation.destroy_all
Membership.destroy_all
Group.destroy_all
User.destroy_all

puts "Creating Users..."
alice = User.create!(username: "Alice", email_address: "alice@example.com", password: "password123", password_confirmation: "password123")
bob = User.create!(email_address: "b@b.c", password: "password123", password_confirmation: "password123")
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

# 5. Create Operations and Participations

# Scenario A: Alice pays for a Welcome Dinner ($150), split equally among all 3.
puts "Creating Operation: Welcome Dinner..."
dinner_op = Operation.create!(
  name: "Welcome Dinner",
  total_amount: 150.00,
  date: DateTime.now - 2.days,
  group: ski_trip,
  author: alice # Alice is the 'AuthorOfOperation' (The Payer)
)

# Create the shares (Participants)
[ alice, bob, raph ].each do |user|
  Participation.create!(
    user: user,
    operation: dinner_op,
    amount_share: 50.00
  )
end

# Scenario B: Bob pays for Gas ($60), split only between Bob and Charlie (Alice didn't come in the car).
puts "Creating Operation: Gas..."
gas_op = Operation.create!(
  name: "Gas for the drive up",
  total_amount: 60.00,
  date: DateTime.now - 3.days,
  group: ski_trip,
  author: bob # Bob is the 'AuthorOfOperation'
)

# Only Bob and Charlie participate in this cost
Participation.create!(user: bob, operation: gas_op, amount_share: 30.00)
Participation.create!(user: raph, operation: gas_op, amount_share: 30.00)

puts "✅ Done! Seeded #{User.count} users, #{Group.count} groups, and #{Operation.count} operations."
