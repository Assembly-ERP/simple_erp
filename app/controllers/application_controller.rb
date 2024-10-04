# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  private

  def or_q(query)
    query.present? ? ' OR' : ''
  end
end
