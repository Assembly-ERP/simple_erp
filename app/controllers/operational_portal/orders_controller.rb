# frozen_string_literal: true

module OperationalPortal
  class OrdersController < OperationalPortal::NormalOperationController
    load_and_authorize_resource except: :search_results
    authorize_resource class: false, only: :search_results

    def index
      query_instance = Order.with_customer.with_order_status.not_voided.sort_desc

      if params[:search].present? && params[:search_by].present?
        search_query = ''
        search_query += 'customers.name ILIKE :search' if params[:search_by].include?('customer_name')
        search_query += "#{or_q(search_query)} orders.formatted_id ILIKE :search" if params[:search_by].include?('id')

        query_instance = query_instance.where(search_query, search: "%#{params[:search]}%") if search_query.present?
      end

      if params[:order_status_id].present? && params[:order_status_id] != 'all'
        query_instance = query_instance.where(order_status_id: params[:order_status_id])
      end

      query_instance = query_instance.accessible_by(current_ability)

      @pagy, @orders = pagy(query_instance, request_path: search_operational_portal_orders_path)
    end

    def search
      index
    end

    def make_ticket
      pdf = OrderPdf.new(@order)
      pdf.make_ticket

      send_data(
        pdf.render,
        filename: "order_make_ticket_#{@order.formatted_id}_#{Time.zone.now.to_i}.pdf",
        type: 'application/pdf',
        disposition: 'inline'
      )
    end

    def qoute_or_invoice
      pdf = OrderPdf.new(@order)
      pdf.quote_or_invoice
      is_quote = !@order.order_status.customer_locked

      send_data(
        pdf.render,
        filename: "order_#{is_quote ? 'quote' : 'invoice'}_#{@order.formatted_id}_#{Time.zone.now.to_i}.pdf",
        type: 'application/pdf',
        disposition: 'inline'
      )
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

    def update_summary
      respond_to do |format|
        if @order.update(update_summary_params)
          format.turbo_stream
        else
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
      query_instance =
        (if params[:search_by].blank? || params[:search_by] == 'all'
           Product.from("(#{search_items(Part).to_sql} UNION #{search_items(Product).to_sql}) products")
         else
           params[:search_by] == 'parts' ? search_items(Part) : search_items(Product)
         end)

      query_instance = query_instance.order(created_at: :desc)

      @pagy, @results = pagy(query_instance, items: 150)

      respond_to do |format|
        format.turbo_stream
      end
    end

    private

    def order_params
      params.require(:order).permit(
        :status, :customer_id, :order_status_id, :shipping_price, :discount_percentage,
        :tax, :send_quote_assignees, :internal_note,
        order_details_attributes: %i[id product_id part_id quantity price override _destroy],
        order_shipping_address_attributes: %i[id name phone state street city zip_code],
        user_ids: []
      )
    end

    def update_summary_params
      params.require(:order).permit(:shipping_price, :discount_percentage, :tax)
    end

    def search_items(model)
      items = model.not_voided
      items = items.search_results
      items = items.search_results_with_order(params[:order_id]) if params[:order_id].present?

      if params[:filter_by].present? && params[:search].present?
        case params[:filter_by]
        when 'name'
          items = items.where('name ILIKE ?', "%#{params[:search]}%")
        end
      end

      items
    end
  end
end
