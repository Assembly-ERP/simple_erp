# frozen_string_literal: true

class PartsProduct < ApplicationRecord
  belongs_to :product, touch: true
  belongs_to :part
end

# == Schema Information
#
# Table name: parts_products
#
#  id         :bigint           not null, primary key
#  quantity   :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  part_id    :bigint           not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_parts_products_on_part_id                 (part_id)
#  index_parts_products_on_part_id_and_product_id  (part_id,product_id) UNIQUE
#  index_parts_products_on_product_id              (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (part_id => parts.id)
#  fk_rails_...  (product_id => products.id)
#
