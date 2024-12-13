# frozen_string_literal: true

class Billing < ApplicationRecord
  def self.client
    Billing.first
  end
end

# == Schema Information
#
# Table name: billings
#
#  id                 :bigint           not null, primary key
#  enable_integration :boolean          default(FALSE), not null
#  manual_payment     :boolean          default(TRUE), not null
#  pay_later          :boolean          default(TRUE), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
