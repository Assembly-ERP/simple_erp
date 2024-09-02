# frozen_string_literal: true

module OperationalPortal
  class CustomersController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      @customers = Customer.accessible_by(current_ability)
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
        render :new
      end
    end

    def update
      if @customer.update(customer_params)
        redirect_to operational_portal_customer_path(@customer), notice: 'Customer was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @customer.destroy
      redirect_to operational_portal_customers_path, notice: 'Customer was successfully destroyed.'
    end

    private

    def customer_params
      params.require(:customer).permit(:name, :phone, :street, :city, :state, :postal_code, :discount)
    end
  end
end
