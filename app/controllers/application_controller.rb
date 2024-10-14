# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Catalog
  include ClientInfo
  include QueryFilter
end
