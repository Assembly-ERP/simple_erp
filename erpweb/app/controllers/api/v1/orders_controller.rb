# frozen_string_literal: true

# app/controllers/api/v1/orders_controller.rb
module Api
  module V1
    class OrdersController < BaseController
      before_action :set_order, only: %i[show update destroy]

      def index
        @orders = current_user.customer.orders
        render json: @orders
      end

      def show
        render json: @order
      end

      def create
        @order = current_user.customer.orders.new(order_params)
        if @order.save
          render json: @order, status: :created
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      end

      def update
        if @order.update(order_params)
          render json: @order
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @order.destroy
        render json: { message: 'Order deleted' }, status: :ok
      end

      private

      def set_order
        @order = current_user.customer.orders.find(params[:id])
      end

      def order_params
        params.require(:order).permit(:status, :total, :shipping_date)
      end
    end
  end
end
