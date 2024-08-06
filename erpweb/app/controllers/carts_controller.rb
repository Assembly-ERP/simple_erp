# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart = current_user.cart || current_user.create_cart
  end

  def add_item
    @cart = current_user.cart || current_user.create_cart
    @cart_item = @cart.cart_items.new(cart_item_params)
    if @cart_item.save
      redirect_to cart_path, notice: 'Item added to cart.'
    else
      redirect_to request.referer, alert: 'Unable to add item to cart.'
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :part_id, :quantity)
  end
end
