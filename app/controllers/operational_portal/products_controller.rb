# frozen_string_literal: true

module OperationalPortal
  class ProductsController < OperationalPortal::BaseController
    load_and_authorize_resource except: :search_part_results
    authorize_resource class: false, only: :search_part_results

    def index
      @products = Product.accessible_by(current_ability)
    end

    def show; end

    def new; end

    def edit; end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to operational_portal_catalog_index_path, notice: 'Product was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @product.update(product_params)
        redirect_to operational_portal_catalog_index_path, notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @product.destroy!
      redirect_to operational_portal_catalog_index_path, notice: 'Product was successfully deleted.'
    end

    def search_part_results
      @parts = Part.all
      @parts = @parts.order(id: params[:sort]) if params[:sort].present?
      @parts = @parts.with_product(params[:product_id]) if params[:product_id].present?

      if params[:search].present?
        case params[:filter_by]
        when 'name'
          @parts = @parts.where('name ILIKE ?', "%#{params[:search]}%")
        end
      end

      respond_to do |format|
        format.turbo_stream
      end
    end

    private

    def product_params
      params.require(:product)
            .permit(:name, :description, :price, parts_products_attributes: %i[id name part_id quantity _destroy])
    end
  end
end
