# frozen_string_literal: true

class ConsolidatedUsersMigration < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      ## Devise fields
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Additional fields
      t.references :customer, foreign_key: true, null: true
      t.string :role
      t.string :type
      t.string :name
      t.string :phone
      t.string :firstName
      t.string :lastName

      ## Devise recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Devise rememberable
      t.datetime :remember_created_at

      ## Timestamps
      t.timestamps null: false
    end

    ## Devise indexes
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true

    ## Optional: Additional indexes
    # add_index :users, :confirmation_token, unique: true
    # add_index :users, :unlock_token, unique: true
  end
end
