# frozen_string_literal: true

class OrderStatusTrail < ApplicationRecord
  belongs_to :order
  belongs_to :order_status
end

# == Schema Information
#
# Table name: order_status_trails
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  order_id        :bigint           not null
#  order_status_id :bigint           not null
#
# Indexes
#
#  index_order_status_trails_on_order_id         (order_id)
#  index_order_status_trails_on_order_status_id  (order_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (order_status_id => order_statuses.id)
#
