# frozen_string_literal: true

module OperationalPortal
  class OrdersController < OperationalPortal::BaseController
    load_and_authorize_resource

    def index
      @orders = Order.accessible_by(current_ability)
    end

    def show; end

    def new; end

    def edit; end

    def create
      @order = Order.new(order_params)

      if @order.save
        redirect_to operational_portal_order_path(@order), notice: 'Order created successfully.'
      else
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
end
