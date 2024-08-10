# frozen_string_literal: true

class Transporter < ApplicationRecord
  validates :name, presence: true
  validates :contact_info, presence: true
end

# == Schema Information
#
# Table name: transporters
#
#  id           :bigint           not null, primary key
#  api_details  :json
#  contact_info :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
