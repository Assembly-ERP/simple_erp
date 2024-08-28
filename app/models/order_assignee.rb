# frozen_string_literal: true

class OrderAssignee < ApplicationRecord
  belongs_to :order
  belongs_to :user
end

# == Schema Information
#
# Table name: order_assignees
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_order_assignees_on_order_id  (order_id)
#  index_order_assignees_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (user_id => users.id)
#
