# frozen_string_literal: true

module OperationalPortal
  class ProductsController < OperationalPortal::BaseController
    load_and_authorize_resource except: :search_part_results
    authorize_resource class: false, only: :search_part_results

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
      respond_to do |format|
        if @product.update(voided_at: Time.zone.now)
          format.html { redirect_to operational_portal_catalog_index_path, notice: 'Product was successfully voied.' }
          format.turbo_stream
        else
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    def search_part_results
      query_instance = Part.not_voided
      query_instance = query_instance.order(id: params[:sort]) if params[:sort].present?
      query_instance = query_instance.with_product(params[:product_id]) if params[:product_id].present?

      if params[:search].present?
        case params[:filter_by]
        when 'name'
          query_instance = query_instance.where('name ILIKE ?', "%#{params[:search]}%")
        end
      end

      @pagy, @parts = pagy(query_instance, items: 40)
    end

    private

    def product_params
      params.require(:product).permit(
        :name, :description, :price, :sku, :nmfc, :category,
        parts_products_attributes: %i[id name part_id quantity _destroy],
        images: [], poly_attributes_attributes: %i[id value label _destroy]
      )
    end
  end
end
