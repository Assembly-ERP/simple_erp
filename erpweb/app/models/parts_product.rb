# app/models/parts_product.rb
class PartsProduct < ApplicationRecord
    belongs_to :product
    belongs_to :part
  end
  