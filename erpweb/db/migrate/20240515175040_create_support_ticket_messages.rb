# frozen_string_literal: true

class CreateSupportTicketMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :support_ticket_messages do |t|
      t.references :support_ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
