# frozen_string_literal: true

module CustomerPortal
  class ProductsController < BaseController
    load_and_authorize_resource

    def show; end
  end
end
