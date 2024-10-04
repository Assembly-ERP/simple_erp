# frozen_string_literal: true

module CustomerPortal
  class CartController < BaseController
    authorize_resource class: false

    def index; end
  end
end
