class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :street    # Added street column
      t.string :city      # Added city column
      t.string :state     # Added state column
      t.string :postal_code # Added postal_code column
      t.decimal :discount, precision: 5, scale: 2, default: 0 # Added discount column

      t.timestamps
    end
  end
end
