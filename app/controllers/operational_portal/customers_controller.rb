# frozen_string_literal: true

module OperationalPortal
  class CustomersController < OperationalPortal::ManageBaseController
    load_and_authorize_resource

    def index
      query_instance = Customer.not_voided

      if params[:search].present? && params[:search_by].present?
        search_query = ''
        search_query += 'name ILIKE :search' if params[:search_by].include?('name')
        search_query += "#{or_q(search_query)} phone ILIKE :search" if params[:search_by].include?('phone')
        search_query += "#{or_q(search_query)} city ILIKE :search" if params[:search_by].include?('city')
        search_query += "#{or_q(search_query)} state ILIKE :search" if params[:search_by].include?('state')

        query_instance = query_instance.where(search_query, search: "%#{params[:search]}%") if search_query.present?
      end

      query_instance = query_instance.sort_desc.accessible_by(current_ability)

      @pagy, @customers = pagy(query_instance)

      respond_to do |format|
        format.html
        format.turbo_stream if filter_stream_condition?
      end
    end

    def show; end

    def users
      @users = @customer.users
    end

    def new; end

    def edit; end

    def create
      @customer = Customer.new(customer_params)

      if @customer.save
        redirect_to operational_portal_customers_path, notice: 'Customer was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @customer.update(customer_params)
        redirect_to operational_portal_customers_path, notice: 'Customer was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      respond_to do |format|
        if @customer.update(voided_at: Time.zone.now)
          format.html do
            redirect_to operational_portal_customers_path, notice: 'Customer was successfully deleted.'
          end
        end
      end
    end

    private

    def customer_params
      params.require(:customer).permit(:name, :phone, :ein, :street, :city, :state, :postal_code, :discount)
    end
  end
end
