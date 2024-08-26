# frozen_string_literal: true

module OperationalPortal
  class CatalogController < OperationalPortal::BaseController
    authorize_resource class: false

    def index
      products = Product.for_union_with_parts
      parts = Part.for_union_with_products

      @items = Product.from("(#{products.to_sql} UNION #{parts.to_sql}) products")
    end
  end
end
