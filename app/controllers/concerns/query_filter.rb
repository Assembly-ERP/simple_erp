# frozen_string_literal: true

module QueryFilter
  extend ActiveSupport::Concern

  def or_q(query)
    query.present? ? ' OR' : ''
  end

  def filter_stream_condition?
    params[:page].present? || params[:filter_by].present? || params[:search_by].present? ||
      params[:order_status_id].present?
  end
end
