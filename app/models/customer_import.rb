# frozen_string_literal: true

class CustomerImport < ApplicationRecord
  # Contants
  ALLOWED_FILE_TYPES = %w[text/csv].freeze
  STATUSES = %w[pending success failed].freeze

  # Relations
  belongs_to :created_by, class_name: 'User'

  # Attachments
  has_one_attached :sheet
  has_one_attached :log

  # Scopes
  default_scope { order(id: :desc) }

  # Validations
  validates :sheet, attached: true, content_type: ALLOWED_FILE_TYPES
  after_create :process_sheet_import

  private

  def process_sheet_import
    CustomerImportJob.perform_async(id)
  end
end

# == Schema Information
#
# Table name: customer_imports
#
#  id            :bigint           not null, primary key
#  current_row   :integer          default(0), not null
#  status        :string           default("pending"), not null
#  total_rows    :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :bigint
#
# Indexes
#
#  index_customer_imports_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
