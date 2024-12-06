# frozen_string_literal: true

class PaymentOption < ApplicationRecord
end

# == Schema Information
#
# Table name: payment_options
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE), not null
#  api_token  :string
#  api_url    :string
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_payment_options_on_code  (code) UNIQUE
#
