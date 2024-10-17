# frozen_string_literal: true

class CreatePolyAttributes < ActiveRecord::Migration[7.1]
  def change
    create_table :poly_attributes do |t|
      t.references :attributable, polymorphic: true, null: false
      t.string :input_type, null: false, default: 'text'
      t.string :label, null: false
      t.string :value

      t.timestamps
    end
  end
end
