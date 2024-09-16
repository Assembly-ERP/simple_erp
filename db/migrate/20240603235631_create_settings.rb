# frozen_string_literal: true

class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.string :key, null: false
      t.string :code, null: false
      t.decimal :value, precision: 10, scale: 2, default: 0.0
      t.boolean :active, null: false, default: false

      t.timestamps
    end

    add_index :settings, %i[key code], unique: true

    reversible do |dir|
      dir.up do
        Setting.create(key: 'Price Per Pound', code: 'ppp', active: true)
      end
    end
  end
end
