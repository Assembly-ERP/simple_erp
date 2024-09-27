# frozen_string_literal: true

class AddOrderColInternalNote < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :internal_note, :text
  end
end
