# frozen_string_literal: true

# app/controllers/operational_portal/products_controller.rb
module OperationalPortal
  class ProductsController < OperationalPortal::BaseController
    load_and_authorize_resource

    def index
      @products = Product.accessible_by(current_ability)
    end

    def show; end

    def new
      @product = Product.new
      @parts = Part.all
    end

    def edit; end

    def create
      @product = Product.new(product_params.except(:part_quantities))
      if @product.save
        redirect_to operational_portal_product_path(@product), notice: 'Product was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @product.update
        redirect_to operational_portal_product_path(@product), notice: 'Product was successfully updated.'
      else
        @parts = Part.all
        render :edit
      end
    end

    def destroy
      @product.destroy!
      redirect_to operational_portal_catalog_path, notice: 'Product was successfully deleted.'
    end

    def search_parts
      @parts = Part.where('name ILIKE ?', "%#{params[:q]}%")
      render json: @parts
    end

    private

    def product_params
      params.require(:product).permit(:name, :description, :price)
    end

    def calculate_total_price(parts, part_quantities)
      # parts.sum { |part| part.price.to_f * part_quantities[part.id.to_s].to_i }
      parts.sum do |part|
        quantity = part_quantities[part.id.to_s].to_i
        part.price.to_f * quantity
      end
    end
  end
end
