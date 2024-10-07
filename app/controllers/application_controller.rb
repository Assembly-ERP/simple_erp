# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  private

  def or_q(query)
    query.present? ? ' OR' : ''
  end

  def filter_stream_condition?
    params[:page].present? || params[:filter_by].present? || params[:search_by].present?
  end
end
