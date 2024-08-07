# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Clear existing data
# Create an admin user
if Rails.env.development?
  User.create(
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'admin',
    firstName: 'Tim',
    lastName: 'Smith',
    name: 'Tim Smith',
    confirmed_at: Time.now.utc
  )

  # Create customers
  customer1 = Customer.create(
    name: 'Big Shop',
    address: '123 Main St',
    phone: '123-456-7890',
    street: '123 Main St',
    city: 'Cityville',
    state: 'CA',
    postal_code: '12345',
    discount: 10.00
  )

  customer2 = Customer.create(
    name: 'The Store',
    address: '456 Elm St',
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
  part1 = Part.create(
    name: 'Part One',
    description: 'This is part one',
    price: 100.00,
    in_stock: 50,
    weight: 1.0,
    manual_price: true,
    inventory: true
  )

  part2 = Part.create(
    name: 'Part Two',
    description: 'This is part two',
    price: 200.00,
    in_stock: 30,
    weight: 2.0,
    manual_price: true,
    inventory: true
  )

  # Create products
  product1 = Product.create(
    name: 'Product One',
    description: 'This is product one'
  )

  product2 = Product.create(
    name: 'Product Two',
    description: 'This is product two'
  )

  # Associate parts with products
  PartsProduct.create!(part: part1, product: product1, quantity: 2)
  PartsProduct.create!(part: part2, product: product1, quantity: 1)
  PartsProduct.create!(part: part1, product: product2, quantity: 1)
  PartsProduct.create!(part: part2, product: product2, quantity: 2)

  # Manually trigger price and weight calculations for products
  [product1, product2].each do |product|
    product.send(:calculate_weight)
    product.update!(price: product.price)
  end

  # Create orders with order details
  order1 = Order.create!(
    customer: customer1,
    status: 'pre_order',
    order_details_attributes: [
      { product: product1, quantity: 1, price: product1.price },
      { part: part1, quantity: 2, price: part1.price }
    ]
  )

  order2 = Order.create!(
    customer: customer2,
    status: 'created',
    order_details_attributes: [
      { product: product2, quantity: 1, price: product2.price },
      { part: part2, quantity: 2, price: part2.price }
    ]
  )

  # Recalculate total amounts for orders
  [order1, order2].each do |order|
    order.update!(total_amount: order.order_details.sum(&:subtotal))
  end

  puts 'Seed data created successfully!'
end
