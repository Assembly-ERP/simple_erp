# frozen_string_literal: true

module OperationalPortal
  class OrdersController < OperationalPortal::NormalOperationController
    load_and_authorize_resource except: :search_results
    authorize_resource class: false, only: :search_results

    def index
      @orders = Order.with_customer.with_order_status.not_voided.accessible_by(current_ability)
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

        format.turbo_stream
      end
    end

    def sync_price
      respond_to do |format|
        if @order.update(updated_at: Time.zone.now)
          format.html { render :edit, status: :ok }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @order.update(voided_at: Time.zone.now)
          format.html { redirect_to operational_portal_orders_path, notice: 'Order was successfully voided.' }
        end
        format.turbo_stream
      end
    end

    def search_results
      @results = params[:search_by] == 'parts' ? Part.all : Product.all
      @results = @results.order(id: params[:sort]) if params[:sort].present?
      @results = @results.search_results

      @results = @results.search_results_with_order(params[:order_id]) if params[:order_id].present?

      if params[:search].present?
        case params[:filter_by]
        when 'name'
          @results = @results.where('name ILIKE ?', "%#{params[:search]}%")
        end
      end

      respond_to do |format|
        format.turbo_stream
      end
    end

    private

    def order_params
      params.require(:order)
            .permit(:status, :customer_id, :order_status_id, :shipping_price, :discount_percentage, :tax,
                    order_details_attributes: %i[id product_id part_id quantity price override _destroy],
                    order_assignee_attributes: %i[id user_id _destroy],
                    order_shipping_address_attributes: %i[id state street city zip_code])
    end
  end
end
