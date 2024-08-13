# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  def index
    @customers = Customer.all
  end

  def show; end

  def new
    @customer = Customer.new
  end

  def edit; end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      upsert_document('customers', customer_document(@customer))
      ActionCable.server.broadcast 'customers', { id: @customer.id, name: @customer.name }
      render json: @customer, status: :created
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  def update
    if @customer.update(customer_params)
      upsert_document('customers', customer_document(@customer))
      ActionCable.server.broadcast 'customers', { id: @customer.id, name: @customer.name }
      redirect_to @customer, notice: 'Customer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @customer.destroy
    TYPESENSE_CLIENT.collections['customers'].documents[@customer.id.to_s].delete
    redirect_to customers_url, notice: 'Customer was successfully destroyed.'
  end

  def search
    if params[:query].present?
      search_params = {
        q: params[:query],
        query_by: 'name,phone,street,city,state,postal_code'
      }
      @customers = TYPESENSE_CLIENT.collections['customers'].documents.search(search_params)['hits'].pluck('document')
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
