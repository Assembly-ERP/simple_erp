# frozen_string_literal: true

module QueryFilter
  extend ActiveSupport::Concern

  def or_q(query)
    query.present? ? ' OR' : ''
  end
end
