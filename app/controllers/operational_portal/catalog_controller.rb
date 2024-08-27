# frozen_string_literal: true

module OperationalPortal
  class CatalogController < OperationalPortal::BaseController
    authorize_resource class: false

    def index
      products = Product.catalog
      parts = Part.catalog

      @items = Product.from("(#{products.to_sql} UNION #{parts.to_sql}) products").order(id: :desc)
    end
  end
end
