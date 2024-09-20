# frozen_string_literal: true

class CustomerImport < ApplicationRecord
  # Contants
  ALLOWED_FILE_TYPES = %w[text/csv].freeze
  STATUSES = %w[pending success failed].freeze

  # Attachments
  has_one_attached :sheet
  has_one_attached :log

  # Validations
  validates :sheet, attached: true, content_type: ALLOWED_FILE_TYPES

  # Generators
  after_save :process_sheet_import

  private

  # Run background job
  def process_sheet_import; end
end
