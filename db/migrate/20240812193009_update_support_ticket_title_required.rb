# frozen_string_literal: true

class UpdateSupportTicketTitleRequired < ActiveRecord::Migration[7.1]
  def change
    change_column_null :support_tickets, :title, false
    change_column_null :support_tickets, :issue_description, false
  end
end
