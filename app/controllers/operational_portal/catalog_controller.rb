# frozen_string_literal: true

module OperationalPortal
  class CatalogController < OperationalPortal::NormalOperationController
    include Catalog

    authorize_resource class: false
  end
end
