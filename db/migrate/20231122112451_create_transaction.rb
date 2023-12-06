class CreateTransaction < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
     t.integer :amount
     t.text :description
     t.integer :customer_id

      t.timestamps
    end
  end
end
