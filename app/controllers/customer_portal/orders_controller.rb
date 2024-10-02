# frozen_string_literal: true

module CustomerPortal
  class OrdersController < BaseController
    load_and_authorize_resource

    def index
      @pagy, @orders = pagy(Order.accessible_by(current_ability))
    end

    def show; end

    def new; end

    def edit; end

    def create
      @order = current_user.orders.new(order_params)
      if @order.save
        redirect_to customer_portal_order_path(@order), notice: 'Order created successfully.'
      else
        render :new
      end
    end

    def update
      if @order.update(order_params)
        redirect_to customer_portal_order_path(@order), notice: 'Order was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @order.destroy
      redirect_to customer_portal_orders_path, notice: 'Order was successfully cancelled.'
    end

    private

    def order_params
      params.require(:order).permit(:status, :total)
    end
  end
end
