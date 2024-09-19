# frozen_string_literal: true

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
  User.create(
    first_name: 'John',
    last_name: 'Doe',
    email: 'cxadmin@fake.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'customer_user_admin',
    customer: customer1,
    confirmed_at: Time.now.utc
  )

  User.create(
    first_name: 'Jane',
    last_name: 'Smith',
    email: 'cxregular@fake.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'customer_user_regular',
    customer: customer2,
    confirmed_at: Time.now.utc
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
else
  puts 'Development seed migration skipped'
end
