# app/controllers/operational_portal/products_controller.rb
module OperationalPortal
  class ProductsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_operational_user
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      @products = Product.all
    end

    def show
    end

    def new
      @product = Product.new
      @parts = Part.all
    end

    def create
      @product = Product.new(product_params.except(:part_quantities))
      if @product.save
        update_product_parts(@product, product_params[:part_quantities])
        @product.update(price: calculate_total_price(@product.parts, product_params[:part_quantities]))
        @product.save  # This will trigger the calculate_weight callback
        redirect_to operational_portal_product_path(@product), notice: 'Product was successfully created.'
      else
        @parts = Part.all
        render :new
      end
    end

    def edit
      @parts = Part.all
    end

    def update
      if @product.update(product_params.except(:part_quantities))
        update_product_parts(@product, product_params[:part_quantities])
        @product.update(price: calculate_total_price(@product.parts, product_params[:part_quantities]))
        @product.save  # This will trigger the calculate_weight callback
        redirect_to operational_portal_product_path(@product), notice: 'Product was successfully updated.'
      else
        @parts = Part.all
        render :edit
      end

      # @product.assign_attributes(product_params.except(:part_quantities))
      
      # begin
      #   Product.transaction do
      #     update_product_parts(@product, product_params[:part_quantities])
      #     @product.save!
      #   end
      #   redirect_to operational_portal_product_path(@product), notice: 'Product was successfully updated.'
      # rescue ActiveRecord::RecordInvalid => e
      #   @parts = Part.all
      #   flash.now[:alert] = "Failed to update product: #{@product.errors.full_messages.join(', ')}"
      #   render :edit
      # end
    end


    def destroy
      @product.destroy
      redirect_to operational_portal_catalog_path, notice: 'Product was successfully deleted.'
    end

    def search_parts
      @parts = Part.where('name ILIKE ?', "%#{params[:q]}%")
      render json: @parts
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, part_quantities: {})
    end    

    def update_product_parts(product, part_quantities)
      parts_products_table = ActiveRecord::Base.connection.table_exists?(:parts_products) ? :parts_products : "parts_products"
    
      product.parts.clear
      part_quantities.each do |part_id, quantity|
        next if quantity.to_i.zero?
        part = Part.find(part_id)
        product.parts << part
    
        ActiveRecord::Base.connection.execute(
          "UPDATE #{parts_products_table} SET quantity = #{ActiveRecord::Base.connection.quote(quantity)} WHERE product_id = #{product.id} AND part_id = #{part_id}"
        )
      end
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
