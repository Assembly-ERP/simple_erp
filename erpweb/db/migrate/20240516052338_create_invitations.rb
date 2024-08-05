class CreateInvitations < ActiveRecord::Migration[7.1]
  def change
    create_table :invitations do |t|
      t.string :email
      t.string :token
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
