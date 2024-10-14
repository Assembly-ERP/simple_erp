# frozen_string_literal: true

class Branding < ApplicationRecord
  has_one_attached :logo
  has_rich_text :about_us

  def self.client
    Branding.first
  end
end

# == Schema Information
#
# Table name: brandings
#
#  id                   :bigint           not null, primary key
#  city                 :string
#  ein                  :string
#  name                 :string           not null
#  phone                :string
#  postal_code          :string
#  primary_color        :string           not null
#  primary_text_color   :string           not null
#  secondary_color      :string           not null
#  secondary_text_color :string           not null
#  state                :string
#  street               :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
