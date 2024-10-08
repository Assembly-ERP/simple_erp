# frozen_string_literal: true

module CustomerPortal
  class OrdersController < BaseController
    load_and_authorize_resource

    def index
      query_instance = Order.with_order_status.not_voided.sort_desc

      if params[:search].present? && params[:search_by].present?
        search_query = ''
        search_query += "#{or_q(search_query)} orders.formatted_id ILIKE :search" if params[:search_by].include?('id')

        query_instance = query_instance.where(search_query, search: "%#{params[:search]}%") if search_query.present?
      end

      if params[:order_status_id].present? && params[:order_status_id] != 'all'
        query_instance = query_instance.where(order_status_id: params[:order_status_id])
      end

      query_instance = query_instance.accessible_by(current_ability)

      @pagy, @orders = pagy(query_instance)

      respond_to do |format|
        format.html
        format.turbo_stream if filter_stream_condition?
      end
    end

    def show; end

    def quote_or_invoice
      pdf = OrderPdf.new(@order)
      pdf.quote_or_invoice

      send_data(pdf.render, filename: pdf.quote_or_invoice_filename, type: 'application/pdf', disposition: 'inline')
    end

    def new; end

    def edit; end

    def create_qoute; end

    def create
      @order = current_user.orders.new(order_params)

      if @order.save
        redirect_to customer_portal_order_path(@order), notice: 'Order created successfully.'
      else
        render :new
      end
    end

    def update
      if @order.update(order_params)
        redirect_to customer_portal_order_path(@order), notice: 'Order was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @order.destroy

      redirect_to customer_portal_orders_path, notice: 'Order was successfully cancelled.'
    end

    private

    def order_params
      params.require(:order).permit(:status, :total)
    end
  end
end
