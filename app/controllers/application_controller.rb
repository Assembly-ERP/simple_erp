# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ClientInfo
  include QueryFilter
end
