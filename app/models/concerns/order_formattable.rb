# frozen_string_literal: true

module OrderFormattable
  extend ActiveSupport::Concern

  included do
    before_save :format_identity, if: :new_record?

    def self.latest_yearly_holder
      where('extract(year from created_at) = ?', Time.zone.now.year).maximum(:holder_id) || 0
    end

    private

    def format_identity
      case OrderIdFormat.active_format&.format
      when 'yearly'
        self.holder_id = Order.latest_yearly_holder + 1
        self.formatted_id = "#{Time.zone.now.strftime('%y')}-#{format('%04d', holder_id)}"
      else
        self.holder_id = id
        self.formatted_id = id
      end
    end
  end
end
