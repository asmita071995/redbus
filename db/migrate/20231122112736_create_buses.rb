class CreateBuses < ActiveRecord::Migration[7.0]
  def change
    create_table :buses do |t|
      t.string :name
      t.string :number
      t.integer :total_seats
      t.integer :available_seats
      t.references :bus_route, null: false, foreign_key:true
      t.integer :fare

      t.timestamps
    end
  end
end
