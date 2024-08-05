class AddUserReferenceToSupportTicketMessages < ActiveRecord::Migration[7.1]
  def change
    add_reference :support_ticket_messages, :user, null: false, foreign_key: true
  end
end
