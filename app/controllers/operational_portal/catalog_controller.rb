# frozen_string_literal: true

module OperationalPortal
  class CatalogController < OperationalPortal::NormalOperationController
    authorize_resource class: false

    def index
      query

      respond_to do |format|
        format.html
      end
    end

    def search
      query

      respond_to do |format|
        format.turbo_stream { render :stream }
      end
    end

    private

    def query
      query_instance = Product.from("(#{catalog(Product).to_sql} UNION #{catalog(Part).to_sql}) products")
                              .order(created_at: :desc)

      @pagy, @items = pagy(query_instance)
    end

    def catalog(model)
      instance = model.catalog.not_voided

      if params[:search].present? && params[:search_by].present?
        if params[:search_by].include?('name')
          instance = instance.where('name ILIKE :search', search: "%#{params[:search]}%")
        end
        if params[:search_by].include?('description')
          instance = instance.where('description ILIKE :search', search: "%#{params[:search]}%")
        end
      end

      instance
    end
  end
end
