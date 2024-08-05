class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.string :key, null: false
      t.text :value, null: false

      t.timestamps
    end
    add_index :settings, :key, unique: true

    reversible do |dir|
      dir.up do
        Setting.create(key: 'Price Per Pound', value: '0.00')
      end
    end
  end
end
