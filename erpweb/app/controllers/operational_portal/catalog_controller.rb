# frozen_string_literal: true

module OperationalPortal
  class CatalogController < OperationalPortal::BaseController
    authorize_resource class: false

    def index
      @products = Product.all
      @parts = Part.all
    end
  end
end
