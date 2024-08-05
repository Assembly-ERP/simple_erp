class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = if params[:query].present?
                  Product.where('name ILIKE ?', "%#{params[:query]}%")
                else
                  Product.all
                end
  end

  def show
    @product = Product.find(params[:id])
  end
end
