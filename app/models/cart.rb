# frozen_string_literal: true

class Cart < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :part, optional: true
  belongs_to :product, optional: true

  # Scopes
  scope :sort_asc, -> { order(id: :asc) }
  scope :sort_desc, -> { order(id: :desc) }
  scope :with_part_and_product, lambda {
    select('carts.*, products.name AS product_name, parts.name AS part_name, ' \
           'parts.sku AS part_sku, products.sku AS product_sku, ' \
           'parts.price AS part_price, products.price AS product_price')
      .joins('LEFT JOIN products ON carts.product_id = products.id')
      .joins('LEFT JOIN parts ON carts.part_id = parts.id')
  }

  # Validations
  validates :part, presence: true, unless: :product
  validates :product, presence: true, unless: :part
  validates :quantity, numericality: { greater_than_or_equal_to: 1 }
  validates :user_id, uniqueness: { scope: %i[part_id product_id] }
end

# == Schema Information
#
# Table name: carts
#
#  id         :bigint           not null, primary key
#  quantity   :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  part_id    :bigint
#  product_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_carts_on_part_id                             (part_id)
#  index_carts_on_product_id                          (product_id)
#  index_carts_on_user_id                             (user_id)
#  index_carts_on_user_id_and_part_id_and_product_id  (user_id,part_id,product_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (part_id => parts.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
