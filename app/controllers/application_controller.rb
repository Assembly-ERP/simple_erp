# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include QueryFilter

  private

  def filter_stream_condition?
    params[:page].present? || params[:filter_by].present? || params[:search_by].present? ||
      params[:order_status_id].present?
  end
end
