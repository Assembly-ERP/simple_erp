# frozen_string_literal: true

module CustomerPortal
  class CatalogController < BaseController
    authorize_resource class: false

    def index
      catalog_record
    end
  end
end
