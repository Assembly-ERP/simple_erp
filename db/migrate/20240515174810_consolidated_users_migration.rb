# frozen_string_literal: true

class ConsolidatedUsersMigration < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Devise fields
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Additional fields
      t.references :customer, foreign_key: true, null: true
      t.string :role, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone

      ## Devise recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Devise rememberable
      t.datetime :remember_created_at

      ## Timestamps
      t.timestamps null: false

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
    end

    ## Devise indexes
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true

    ## Optional: Additional indexes
    add_index :users, :confirmation_token, unique: true
  end
end
