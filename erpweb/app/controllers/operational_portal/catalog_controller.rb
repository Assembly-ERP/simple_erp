# frozen_string_literal: true

module OperationalPortal
  class CatalogController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_operational_user

    def index
      @products = Product.all
      @parts = Part.all
    end
  end
end
