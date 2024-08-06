# frozen_string_literal: true

# app/controllers/api/v1/products_controller.rb
module Api
  module V1
    class ProductsController < BaseController
      skip_before_action :verify_authenticity_token
      before_action :set_product, only: %i[show update destroy]

      # GET /api/v1/products
      def index
        @products = Product.page(params[:page]).per(10)
        render json: @products
      end

      # GET /api/v1/products/1
      def show
        render json: @product
      end

      # POST /api/v1/products
      def create
        @product = Product.new(product_params)
        if @product.save
          render json: @product, status: :created
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/products/1
      def update
        if @product.update(product_params)
          render json: @product
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @product = Product.find_by(id: params[:id])
        return render json: { error: 'Product not found' }, status: :not_found unless @product

        @product.destroy
        render json: { message: 'Product deleted' }, status: :ok
      end

      private

      def set_product
        @product = Product.find(params[:id])
      end

      def product_params
        params.require(:product).permit(:name, :description, :price)
      end
    end
  end
end
