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

      respond_to do |format|
        if @order.save
          format.html { redirect_to operational_portal_orders_path, notice: 'Order created successfully.' }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @order.update(order_params)
          format.html { redirect_to operational_portal_orders_path, notice: 'Order updated successfully.' }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @order.destroy

      respond_to do |format|
        format.html { redirect_to operational_portal_orders_path, notice: 'Order was successfully cancelled.' }
      end
    end

    def search_results
      @parts = Part.all
      @parts = @parts.order(id: params[:sort]) if params[:sort].present?

      if params[:search].present?
        case params[:filter_by]
        when 'name'
          @parts = @parts.where('name ILIKE ?', "%#{params[:search]}%")
        end
      end

      respond_to do |format|
        format.turbo_stream
      end
    end

    private

    def order_params
      params.require(:order)
            .permit(:status, :customer_id, order_details_attributes: %i[id product_id part_id quantity price _destroy])
    end
  end
end
