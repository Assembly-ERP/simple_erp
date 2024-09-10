# frozen_string_literal: true

class OrderPriceScheduler < ApplicationRecord
end

# == Schema Information
#
# Table name: order_price_schedulers
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE), not null
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
