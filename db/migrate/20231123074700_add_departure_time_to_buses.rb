class AddDepartureTimeToBuses < ActiveRecord::Migration[7.0]
  def change
    add_column :buses, :departure_time, :datetime
  end
end
