# frozen_string_literal: true

# app/controllers/customer_portal/orders_controller.rb
module CustomerPortal
  class OrdersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_order, only: %i[show edit update destroy]
    before_action :authorize_modify, only: %i[edit update destroy]

    def index
      @orders = if current_user.customer_user?
                  current_user.customer.orders
                else
                  [] # or fetch operational orders if needed
                end
    end

    def show; end

    def new
      @order = current_user.orders.new
      @cart = current_user.is_a?(CustomerUser) ? current_user.cart : nil
    end

    def edit; end

    def create
      @order = current_user.orders.new(order_params)
      if @order.save
        if current_user.is_a?(CustomerUser)
          current_user.cart.cart_items.each do |item|
            if item.product
              @order.order_items.create(product: item.product, quantity: item.quantity)
            elsif item.part
              @order.order_items.create(part: item.part, quantity: item.quantity)
            end
          end
          current_user.cart.cart_items.destroy_all
        end
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

    def set_order
      @order = current_user.customer.orders.find(params[:id])
    end

    def authorize_modify
      return if current_user.customer_user_admin? || @order.user == current_user

      redirect_to customer_portal_order_path(@order), alert: 'You do not have permission to modify this order.'
    end

    def order_params
      params.require(:order).permit(:status, :total)
    end
  end
end
