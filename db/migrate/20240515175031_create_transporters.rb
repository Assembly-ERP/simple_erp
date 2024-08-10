# frozen_string_literal: true

class CreateTransporters < ActiveRecord::Migration[7.1]
  def change
    create_table :transporters do |t|
      t.string :name
      t.string :contact_info
      t.json :api_details

      t.timestamps
    end
  end
end
