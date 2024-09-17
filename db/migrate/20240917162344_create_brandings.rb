# frozen_string_literal: true

class CreateBrandings < ActiveRecord::Migration[7.1]
  def change
    create_table :brandings do |t|
      t.string :name, null: false
      t.string :address
      t.string :state
      t.string :postal_code
      t.string :ein
      t.string :phone
      t.string :primary_color, null: false
      t.string :primary_text_color, null: false
      t.string :secondary_color, null: false
      t.string :secondary_text_color, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Branding.create(
          name: ENV.fetch('CLIENT_NAME', 'Assembly ERP'),
          primary_color: ENV.fetch('PRIMARY_COLOR', '#214290'),
          primary_text_color: ENV.fetch('PRIMARY_TEXT_COLOR', '#fff'),
          secondary_color: ENV.fetch('SECONDARY_COLOR', '#589245'),
          secondary_text_color: ENV.fetch('SECONDARY_TEXT_COLOR', '#fff')
        )
      end
    end
  end
end
