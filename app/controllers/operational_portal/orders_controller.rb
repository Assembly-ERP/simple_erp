# frozen_string_literal: true

# app/controllers/operational_portal/orders_controller.rb
module OperationalPortal
  class OrdersController < OperationalPortal::BaseController
    load_and_authorize_resource

    def index
      @orders = Order.accessible_by(current_ability)
    end

    def show; end

    def fetch_parts
      @parts = Part.all
      render json: @parts.map { |part| part_attributes(part) }
    end

    def fetch_products
      @products = Product.all
      render json: @products.map { |product| product_attributes(product) }
    end

    def new
      @order = Order.new(status: 'pre-order')
      @customers = Customer.all
      @parts = Part.all
      @products = Product.all
    end

    def edit
      @customers = Customer.all
      @parts = Part.all
      @products = Product.all
    end

    def create
      @order = Order.new(order_params)
      @order.status = 'pre-order'

      Rails.logger.debug { "Order params: #{order_params.inspect}" }
      Rails.logger.debug { "Customer ID: #{@order.customer_id}" }

      # Calculate total amount
      # total = @order.order_details.sum { |od| od.quantity * od.price }
      # @order.total_amount = total

      if @order.save
        redirect_to operational_portal_order_path(@order), notice: 'Order created successfully.'
      else
        Rails.logger.debug { "Order errors: #{@order.errors.full_messages}" }
        flash.now[:alert] = @order.errors.full_messages.join(', ')
        @customers = Customer.all
        @parts = Part.all
        @products = Product.all
        render :new
      end
    end

    def update
      if @order.update(order_params)
        redirect_to operational_portal_order_path(@order), notice: 'Order updated successfully.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @order.destroy
      redirect_to operational_portal_orders_path, notice: 'Order was successfully cancelled.'
    end

    def search_items
      query = params[:query]
      parts = Part.where('name ILIKE ?', "%#{query}%").map do |p|
        p.attributes.merge(type: 'part', in_stock: p.in_stock)
      end
      products = Product.where('name ILIKE ?', "%#{query}%").map do |p|
        p.attributes.merge(type: 'product', in_stock: nil)
      end

      render json: (parts + products)
    end

    private

    def order_params
      params.require(:order).permit(:status, :customer_id,
                                    order_details_attributes: %i[id product_id part_id quantity price _destroy])
    end
  end

  def part_attributes(part)
    {
      id: part.id,
      name: part.name,
      description: part.description,
      price: part.price,
      inventory: part.in_stock
    }
  end

  def product_attributes(product)
    {
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price
    }
  end
end
