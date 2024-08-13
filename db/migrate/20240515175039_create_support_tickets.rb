# frozen_string_literal: true

class CreateSupportTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :support_tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.text :issue_description, null: false
      t.string :status, null: false, default: 'pending'
      t.references :customer, foreign_key: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
