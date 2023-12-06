class CreateBusRoutes < ActiveRecord::Migration[7.0]
  def change
    create_table :bus_routes do |t|
      t.integer :available_seats
      t.date :date
      t.integer :from_id
      t.integer :to_id


      t.timestamps
    end
  end
end
