# frozen_string_literal: true

module Api
  module V1
    class OrdersController < BaseController
      load_and_authorize_resource

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

      def order_params
        params.require(:order).permit(:status, :total, :shipping_date)
      end
    end
  end
end
