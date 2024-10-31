# frozen_string_literal: true

module CustomerPortal
  class CatalogController < CustomerPortal::BaseController
    include Catalog

    authorize_resource class: false
  end
end
