# frozen_string_literal: true

module CustomerPortal
  class CartsController < BaseController
    load_and_authorize_resource

    def index
      @carts = Cart.sort_asc.accessible_by(current_ability)
    end

    def create
      @cart = cart_existence || current_user.carts.new(cart_params)

      respond_to do |format|
        if @cart.persisted? ? @cart.update(cart_params) : @cart.save
          format.turbo_stream
        else
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @cart.update(cart_params)
          format.turbo_stream
        else
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @cart.destroy
    end

    private

    def cart_params
      params.require(:cart).permit(:quantity, :part_id, :product_id)
    end

    def cart_existence
      if cart_params[:product_id].present? && cart_params[:part_id].blank?
        return Cart.find_by(user_id: current_user.id, product_id: cart_params[:product_id])
      end

      return nil unless cart_params[:product_id].blank? && cart_params[:part_id].present?

      Cart.find_by(user_id: current_user.id, part_id: cart_params[:part_id])
    end
  end
end
