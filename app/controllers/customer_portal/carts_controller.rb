# frozen_string_literal: true

module CustomerPortal
  class CartsController < BaseController
    load_and_authorize_resource

    def index
      @carts = Cart.accessible_by(current_ability)
    end

    def create
      @cart = current_user.carts.new(cart_params)

      respond_to do |format|
        if @cart.save
          format.turbo_stream
        else
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @cart.update(order_params)
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
  end
end
