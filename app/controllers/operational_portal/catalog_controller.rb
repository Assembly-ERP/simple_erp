# frozen_string_literal: true

module OperationalPortal
  class CatalogController < OperationalPortal::NormalOperationController
    authorize_resource class: false

    def index
      catalog_record
    end
  end
end
