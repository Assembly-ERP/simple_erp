# frozen_string_literal: true

class ChangeSupportTicketStatusDefault < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        change_column_default :support_tickets, :status, 'open'
      end
    end
  end
end
