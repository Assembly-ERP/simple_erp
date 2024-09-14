# frozen_string_literal: true

class OrderIdFormat < ApplicationRecord
  def self.yearly_format; end

  def self.active_format
    find_by(active: true)
  end
end

# == Schema Information
#
# Table name: order_id_formats
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE), not null
#  example    :string
#  format     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_order_id_formats_on_format  (format) UNIQUE
#
