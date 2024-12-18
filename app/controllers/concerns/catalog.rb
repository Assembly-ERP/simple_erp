# frozen_string_literal: true

module Catalog
  extend ActiveSupport::Concern

  included do
    def index
      query_instance = conditional_model
      query_instance = query_instance.sort_newest

      @pagy, @items = pagy(query_instance)

      respond_to do |format|
        format.html
        format.turbo_stream if filter_stream_condition?
      end
    end

    def category_filter
      @category_filter = conditional_model.category_filter
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

      if current_user.present? && params[:min_price].present? && params[:max_price].present?
        query_instance = query_instance.where(price: params[:min_price]..params[:max_price])
      end

      if params[:min_weight].present? && params[:max_weight].present?
        query_instance = query_instance.where(weight: params[:min_weight]..params[:max_weight])
      end

      query_instance = query_instance.where(category: params[:category]) if params[:category].present?

      query_instance
    end

    def conditional_model
      case params[:filter_by]
      when 'products'
        catalog(Product)
      when 'parts'
        catalog(Part)
      else
        Product.from("(#{catalog(Product).to_sql} UNION #{catalog(Part).to_sql}) products")
      end
    end
  end
end
