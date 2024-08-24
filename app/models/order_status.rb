# frozen_string_literal: true

class OrderStatus < ApplicationRecord
  has_many :orders, dependent: :destroy
end

# == Schema Information
#
# Table name: order_statuses
#
#  id         :bigint           not null, primary key
#  inventory  :boolean          default(FALSE), not null
#  locked     :boolean          default(FALSE), not null
#  name       :string           not null
#  reversed   :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
