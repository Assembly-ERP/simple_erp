# frozen_string_literal: true

module OperationalPortal
  class CustomersController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      query_instance = Customer.all

      if params[:search].present? && params[:search_by].present?
        search_query = ''
        search_query += 'name ILIKE :search' if params[:search_by].include?('name')
        search_query += "#{or_q(search_query)}phone ILIKE :search" if params[:search_by].include?('phone')
        search_query += "#{or_q(search_query)}city ILIKE :search" if params[:search_by].include?('city')
        search_query += "#{or_q(search_query)}state ILIKE :search" if params[:search_by].include?('state')

        query_instance = query_instance.where(search_query, search: "%#{params[:search]}%")
      end

      query_instance = query_instance.accessible_by(current_ability)

      @pagy, @customers = pagy(query_instance, request_path: search_operational_portal_customers_path)
    end

    def search
      index
    end

    def show; end

    def users
      @users = @customer.users

      render json: @users
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
