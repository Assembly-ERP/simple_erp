# frozen_string_literal: true

module OperationalPortal
  class OrdersController < OperationalPortal::NormalOperationController
    load_and_authorize_resource except: :search_results
    authorize_resource class: false, only: :search_results

    def index
      @orders = Order.with_customer.with_order_status
                     .not_voided.sort_desc
                     .accessible_by(current_ability)
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
          format.turbo_stream
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @order.update(voided_at: Time.zone.now)
          format.html { redirect_to operational_portal_orders_path, notice: 'Order was successfully voided.' }
          format.turbo_stream
        else
          format.html { redirect_to operational_portal_orders_path, error: 'Something went wrong' }
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    def cancel
      respond_to do |format|
        if @order.update(order_status: OrderStatus.cancel_status)
          format.html { redirect_to operational_portal_orders_path, notice: 'Order was successfully voided.' }
          format.turbo_stream { render :update }
        else
          format.html { redirect_to operational_portal_orders_path, error: 'Something went wrong' }
          format.turbo_stream { render :update, status: :unprocessable_entity }
        end
      end
    end

    def search_results
      @results =
        (if params[:search_by].blank? || params[:search_by] == 'all'
           Product.from("(#{search_parts.to_sql} UNION #{search_products.to_sql}) products")
         else
           params[:search_by] == 'parts' ? search_parts : search_products
         end)

      @results = @results.order(created_at: :desc)

      respond_to do |format|
        format.turbo_stream
      end
    end

    private

    def order_params
      params.require(:order).permit(
        :status, :customer_id, :order_status_id, :shipping_price, :discount_percentage, :tax, :send_quote_assignees,
        order_details_attributes: %i[id product_id part_id quantity price override _destroy],
        order_shipping_address_attributes: %i[id name phone state street city zip_code],
        user_ids: []
      )
    end

    def search_parts
      parts = Part.all
      parts = parts.not_voided
      parts = parts.search_results
      parts = parts.search_results_with_order(params[:order_id]) if params[:order_id].present?

      if params[:filter_by].present? && params[:search].present?
        case params[:filter_by]
        when 'name'
          parts.where('name ILIKE ?', "%#{params[:search]}%")
        end
      end

      parts
    end

    def search_products
      products = Product.all
      products = products.not_voided
      products = products.search_results
      products = products.search_results_with_order(params[:order_id]) if params[:order_id].present?

      if params[:filter_by].present? && params[:search].present?
        case params[:filter_by]
        when 'name'
          products = products.where('name ILIKE ?', "%#{params[:search]}%")
        end
      end

      products
    end
  end
end
