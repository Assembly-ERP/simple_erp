# frozen_string_literal: true

class Cart < ApplicationRecord
  # Relationships
  belongs_to :customer
  belongs_to :user, optional: true
  belongs_to :part, optional: true
  belongs_to :product, optional: true

  # Validations
  validates :part, presence: true, unless: :product
  validates :product, presence: true, unless: :part
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
end

# == Schema Information
#
# Table name: carts
#
#  id          :bigint           not null, primary key
#  quantity    :integer          default(1), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#  part_id     :bigint
#  product_id  :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_carts_on_customer_id  (customer_id)
#  index_carts_on_part_id      (part_id)
#  index_carts_on_product_id   (product_id)
#  index_carts_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (part_id => parts.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
