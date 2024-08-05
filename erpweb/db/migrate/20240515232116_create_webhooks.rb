class CreateWebhooks < ActiveRecord::Migration[7.1]
  def change
    create_table :webhooks do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :url
      t.string :secret_token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
