class CreateSupportTickets < ActiveRecord::Migration[7.1]
  def change
    # Create support_tickets table
    create_table :support_tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.text :issue_description
      t.string :status
      t.references :customer, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
