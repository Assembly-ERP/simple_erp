# frozen_string_literal: true

class PartsProduct < ApplicationRecord
  belongs_to :product
  belongs_to :part
end

# == Schema Information
#
# Table name: parts_products
#
#  quantity   :integer          default(1)
#  part_id    :bigint           not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_parts_products_on_part_id_and_product_id  (part_id,product_id)
#  index_parts_products_on_product_id_and_part_id  (product_id,part_id)
#
