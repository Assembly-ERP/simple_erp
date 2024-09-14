# frozen_string_literal: true

class PolyAttribute < ApplicationRecord
  # Constants
  INPUT_TYPES = %w[text number decimal color].freeze

  # Relationships
  belongs_to :attributable, polymorphic: true

  # Validations
  validates :label, :input_type, :value, presence: true
  validates :input_type, inclusion: { in: INPUT_TYPES }
end

# == Schema Information
#
# Table name: poly_attributes
#
#  id                :bigint           not null, primary key
#  attributable_type :string           not null
#  input_type        :string           default("text"), not null
#  label             :string           not null
#  value             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  attributable_id   :bigint           not null
#
# Indexes
#
#  index_poly_attributes_on_attributable  (attributable_type,attributable_id)
#
