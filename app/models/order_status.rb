# frozen_string_literal: true

class OrderStatus < ApplicationRecord
  has_many :orders, dependent: :destroy
end

# == Schema Information
#
# Table name: order_statuses
#
#  id                :bigint           not null, primary key
#  customer_default  :boolean          default(FALSE), not null
#  inventory         :boolean          default(FALSE), not null
#  locked            :boolean          default(FALSE), not null
#  name              :string           not null
#  operation_default :boolean          default(FALSE), not null
#  reversed          :boolean          default(FALSE), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
