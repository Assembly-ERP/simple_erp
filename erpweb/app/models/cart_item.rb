# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product, optional: true
  belongs_to :part, optional: true
end
