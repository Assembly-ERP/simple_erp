# app/controllers/operational_portal/customers_controller.rb
module OperationalPortal
  class CustomersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_operational_user
    before_action :set_customer, only: [:show, :edit, :update, :destroy]

    def index
      @customers = Customer.all
    end

    def show
      @customer = Customer.find(params[:id])
      render json: @customer
    end

    def details
      @customer = Customer.find(params[:id])
      render json: @customer
    end

    def new
      @customer = Customer.new
    end

    def create
      @customer = Customer.new(customer_params)
      if @customer.save
        redirect_to operational_portal_customers_path, notice: 'Customer was successfully created.'
      else
        render :new
      end
    end

    def edit
      @users = User.where(customer_id: @customer.id)
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

    def search
      if params[:query].present?
        @customers = Customer.where('name LIKE ?', "%#{params[:query]}%")
      else
        @customers = Customer.all
      end

      render json: @customers
    end

    private

    def set_customer
      @customer = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:name, :phone, :street, :city, :state, :postal_code, :discount)
    end
  end
end
