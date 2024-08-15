# frozen_string_literal: true

# Create an admin user
User.create(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password',
  role: 'admin',
  name: 'Tim Smith',
  confirmed_at: Time.now.utc
)

if Rails.env.development? || ENV['FORCE_MIGRATE'] == 'true'
  # Create customers
  customer1 = Customer.create(
    name: 'Big Shop',
    phone: '123-456-7890',
    street: '123 Main St',
    city: 'Cityville',
    state: 'CA',
    postal_code: '12345',
    discount: 10.00
  )

  customer2 = Customer.create(
    name: 'The Store',
    phone: '987-654-3210',
    street: '456 Elm St',
    city: 'Townsville',
    state: 'NY',
    postal_code: '67890',
    discount: 15.00
  )

  # Create some customer users
  customer_user1 = User.create(
    name: 'Admin Customer',
    email: 'cxadmin@fake.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'customer_user_admin',
    customer: customer1,
    confirmed_at: Time.now.utc
  )

  customer_user2 = User.create(
    name: 'Regular Customer',
    email: 'cxregular@fake.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'customer_user_regular',
    customer: customer2,
    confirmed_at: Time.now.utc
  )

  # Create some support tickets
  SupportTicket.create(
    title: 'Issue with Product A',
    issue_description: 'Description of issue with Product A',
    status: 'open',
    customer: customer1,
    user: customer_user1
  )

  SupportTicket.create(
    title: 'Issue with Service B',
    issue_description: 'Description of issue with Service B',
    status: 'pending',
    customer: customer2,
    user: customer_user2
  )

  # Create parts
  part1 = Part.create!(
    name: 'Part One',
    description: 'This is part one',
    price: 100.00,
    in_stock: 50,
    weight: 1.0,
    manual_price: true,
    inventory: true
  )

  part2 = Part.create!(
    name: 'Part Two',
    description: 'This is part two',
    price: 200.00,
    in_stock: 30,
    weight: 2.0,
    manual_price: true,
    inventory: true
  )

  # Create products
  product1 = Product.create!(
    name: 'Product One',
    description: 'This is product one',
    parts_products_attributes: [
      { part_id: part1.id, quantity: 2 },
      { part_id: part2.id, quantity: 1 }
    ]
  )

  product2 = Product.create!(
    name: 'Product Two',
    description: 'This is product two',
    parts_products_attributes: [
      { part_id: part1.id, quantity: 2 },
      { part_id: part2.id, quantity: 1 }
    ]
  )

  # Manually trigger price and weight calculations for products
  [product1, product2].each do |product|
    product.send(:calculate_weight)
    product.update(price: product.price)
  end
end

puts 'Seed data created successfully!'
