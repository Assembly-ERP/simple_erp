# frozen_string_literal: true

module OperationalPortal
  class CatalogController < OperationalPortal::NormalOperationController
    authorize_resource class: false

    def index
      query_instance = Product.from("(#{catalog(Product).to_sql} UNION #{catalog(Part).to_sql}) products")
                              .order(created_at: :desc)

      @pagy, @items = pagy(query_instance)
    end

    def search
      index
    end

    private

    def catalog(model)
      query_instance = model.catalog.not_voided

      if params[:search].present? && params[:search_by].present?
        search_query = ''
        search_query += 'name ILIKE :search' if params[:search_by].include?('name')
        search_query += "#{or_q(search_query)} description ILIKE :search" if params[:search_by].include?('description')
        search_query += "#{or_q(search_query)} sku ILIKE :search" if params[:search_by].include?('sku')

        query_instance = query_instance.where(search_query, search: "%#{params[:search]}%") if search_query.present?
      end

      query_instance
    end
  end
end
